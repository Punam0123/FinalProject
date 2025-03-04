from django.contrib.auth.models import AbstractUser
from django.db import models

class User(AbstractUser):
    address = models.TextField(blank=True, null=True)
    location = models.CharField(max_length=255, blank=True, null=True)
    car_model_name = models.CharField(max_length=255, blank=True, null=True)

    def __str__(self):
        return self.username
