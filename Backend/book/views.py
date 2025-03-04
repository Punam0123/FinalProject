from datetime import datetime
from rest_framework import generics, status
from rest_framework.response import Response
from rest_framework.views import APIView
from django.utils.timezone import now
from .models import ParkingSlot, Booking
from .serializers import ParkingSlotSerializer, BookingSerializer
from payment.models import *
from payment.serializers import PaymentSerializer

# Get all available slots
class AvailableSlotsView(generics.ListAPIView):
    queryset = ParkingSlot.objects.filter(status='available')
    serializer_class = ParkingSlotSerializer

# Get all booked slots
class BookedSlotsView(generics.ListAPIView):
    queryset = Booking.objects.all()
    serializer_class = BookingSerializer

# Book a slot
# {
#     "slot_id": 1,
#     "start_time": "2025-03-01T10:00:00Z",
#     "end_time": "2025-03-01T12:00:00Z"
# }

# class BookSlotView(APIView):
#     def post(self, request):
#         user = request.user
#         slot_id = request.data.get("slot_id")
#         start_time = request.data.get("start_time")
#         end_time = request.data.get("end_time")

#         # Validate input data
#         if not slot_id or not start_time or not end_time:
#             return Response({"error": "Missing required fields"}, status=status.HTTP_400_BAD_REQUEST)

#         # Check if slot exists
#         try:
#             slot = ParkingSlot.objects.get(id=slot_id)
#         except ParkingSlot.DoesNotExist:
#             return Response({"error": "Slot does not exist"}, status=status.HTTP_404_NOT_FOUND)

#         # Check if slot is already booked in that time range
#         overlapping_bookings = Booking.objects.filter(
#             slot=slot,
#             start_time__lt=end_time,  # Existing booking starts before requested end time
#             end_time__gt=start_time   # Existing booking ends after requested start time
#         ).exists()

#         if overlapping_bookings:
#             return Response({"error": "Slot already booked for this time"}, status=status.HTTP_400_BAD_REQUEST)

#         # If slot is physically unavailable (distance < 5cm), prevent booking
#         if slot.status == "unavailable":
#             return Response({"error": "Slot is currently occupied and cannot be booked"}, status=status.HTTP_400_BAD_REQUEST)

#         # Create booking
#         booking = Booking.objects.create(user=user, slot=slot, start_time=start_time, end_time=end_time)

#         # Update slot status to 'booked'
#         slot.status = 'booked'
#         slot.save()

#         return Response(BookingSerializer(booking).data, status=status.HTTP_201_CREATED)


from rest_framework.permissions import IsAuthenticated

class BookSlotView(APIView):
    permission_classes = [IsAuthenticated]  # Ensure the user is authenticated

    def post(self, request):
        user = request.user
        if not user.is_authenticated:
            return Response({"error": "User is not authenticated"}, status=status.HTTP_401_UNAUTHORIZED)
        
        slot_id = request.data.get("slot_id")
        start_time = request.data.get("start_time")
        end_time = request.data.get("end_time")

        if not slot_id or not start_time or not end_time:
            return Response({"error": "Missing required fields"}, status=status.HTTP_400_BAD_REQUEST)

        # Convert to datetime
        try:
            start_time = datetime.fromisoformat(start_time)
            end_time = datetime.fromisoformat(end_time)
        except ValueError:
            return Response({"error": "Invalid datetime format"}, status=status.HTTP_400_BAD_REQUEST)

        if end_time <= start_time:
            return Response({"error": "End time must be after start time"}, status=status.HTTP_400_BAD_REQUEST)

        try:
            slot = ParkingSlot.objects.get(id=slot_id, status="available")
        except ParkingSlot.DoesNotExist:
            return Response({"error": "Slot not available"}, status=status.HTTP_404_NOT_FOUND)

        # Check if slot is booked in the selected time range
        overlapping_bookings = Booking.objects.filter(
            slot=slot,
            start_time__lt=end_time,
            end_time__gt=start_time
        ).exists()

        if overlapping_bookings:
            return Response({"error": "Slot already booked for this time"}, status=status.HTTP_400_BAD_REQUEST)

        # Calculate cost
        hourly_rate = 10  # Example: $10 per hour
        duration_hours = (end_time - start_time).total_seconds() / 3600
        total_cost = round(duration_hours * hourly_rate, 2)

        # Create a pending payment
        payment = Payment.objects.create(user=user, amount=total_cost, status="pending")

        return Response({
            "message": "Proceed to payment",
            "payment": PaymentSerializer(payment).data
        }, status=status.HTTP_200_OK)


class UpdateSlotStatusView(APIView):
    def patch(self, request, slot_id):
        try:
            slot = ParkingSlot.objects.get(id=slot_id)
            distance = float(request.data.get("distance", 100))  # Default far away

            # Always update the distance value
            slot.distance = distance

            # Check if the slot has an active booking at the current time
            is_currently_booked = Booking.objects.filter(
                slot=slot,
                start_time__lte=now(),  # Booking started in the past
                end_time__gte=now()      # Booking is still active
            ).exists()

            # Update slot status based on booking status and distance
            if is_currently_booked:
                slot.status = "booked"  # Keep status booked if there's an active booking
            else:
                slot.status = "unavailable" if distance < 5 else "available"

            slot.save()
            return Response({"message": "Slot status updated"}, status=status.HTTP_200_OK)

        except ParkingSlot.DoesNotExist:
            return Response({"error": "Slot not found"}, status=status.HTTP_404_NOT_FOUND)
