
# Create your models here.
from django.db import models
from user.models import User

class ParkingSlot(models.Model):
    SLOT_STATUS = (
        ('available', 'Available'),
        ('booked', 'Booked'),
        ('unavailable', 'Unavailable'),  # Distance < 5cm
    )
    
    slot_number = models.CharField(max_length=10, unique=True)
    status = models.CharField(max_length=12, choices=SLOT_STATUS, default='available')
    distance = models.FloatField(default=100)  # Default high value

    def __str__(self):
        return f"Slot {self.slot_number} - {self.status}"

class Booking(models.Model):
    STATUS_CHOICES = [
        ("pending", "Pending"),
        ("confirmed", "Confirmed"),
        ("cancelled", "Cancelled"),
    ]
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    slot = models.ForeignKey(ParkingSlot, on_delete=models.CASCADE)
    start_time = models.DateTimeField()
    end_time = models.DateTimeField()
    status = models.CharField(max_length=10, choices=STATUS_CHOICES, default="pending")

    def __str__(self):
        return f"{self.user.username} booked {self.slot.slot_number} from {self.start_time} to {self.end_time}"
