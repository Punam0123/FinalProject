import uuid
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from payment.models import Payment
from book.models import Booking, ParkingSlot
from payment.serializers import PaymentSerializer

# 1️⃣ Create Payment
class CreatePaymentView(APIView):
    def post(self, request):
        user = request.user
        booking_id = request.data.get("booking_id")

        # Validate booking
        try:
            booking = Booking.objects.get(id=booking_id, user=user, status="pending")
        except Booking.DoesNotExist:
            return Response({"error": "Invalid or already processed booking"}, status=status.HTTP_400_BAD_REQUEST)

        # Calculate amount (assuming hourly rate is $5)
        duration_hours = (booking.end_time - booking.start_time).total_seconds() / 3600
        amount = round(duration_hours * 5, 2)  # Example hourly rate

        # Create Payment record
        payment = Payment.objects.create(
            user=user,
            booking=booking,
            amount=amount,
            status="pending",
            transaction_id=str(uuid.uuid4())  # Generate unique transaction ID
        )

        return Response(PaymentSerializer(payment).data, status=status.HTTP_201_CREATED)


# 2️⃣ Process Payment
class ProcessPaymentView(APIView):
    def post(self, request, payment_id):
        try:
            payment = Payment.objects.get(id=payment_id, status="pending")
        except Payment.DoesNotExist:
            return Response({"error": "Invalid or already processed payment"}, status=status.HTTP_400_BAD_REQUEST)

        # Simulate payment success
        transaction_id = str(uuid.uuid4())  # Generate unique transaction ID
        payment.transaction_id = transaction_id
        payment.status = "success"
        payment.save()

        # Mark associated booking as confirmed
        booking = payment.booking
        booking.status = "confirmed"
        booking.save()

        # Mark slot as booked
        slot = booking.slot
        slot.status = "booked"
        slot.save()

        return Response({
            "message": "Payment successful, slot booked",
            "payment": PaymentSerializer(payment).data,
            "booking": {
                "slot": booking.slot.id,
                "start_time": booking.start_time,
                "end_time": booking.end_time
            }
        }, status=status.HTTP_201_CREATED)


# 3️⃣ Get Payment Status
class PaymentStatusView(APIView):
    def get(self, request, payment_id):
        try:
            payment = Payment.objects.get(id=payment_id)
            return Response(PaymentSerializer(payment).data, status=status.HTTP_200_OK)
        except Payment.DoesNotExist:
            return Response({"error": "Payment not found"}, status=status.HTTP_404_NOT_FOUND)
