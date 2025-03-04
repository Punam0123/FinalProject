from django.db import models
from user.models import User
from book.models import Booking

class Payment(models.Model):
    STATUS_CHOICES = [
        ("pending", "Pending"),
        ("success", "Success"),
        ("failed", "Failed"),
    ]

    user = models.ForeignKey(User, on_delete=models.CASCADE)
    booking = models.OneToOneField(Booking, on_delete=models.CASCADE, null=True, blank=True)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    status = models.CharField(max_length=10, choices=STATUS_CHOICES, default="pending")
    transaction_id = models.CharField(max_length=255, unique=True, null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Payment {self.id} - {self.status}"
