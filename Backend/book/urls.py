from django.urls import path
from .views import AvailableSlotsView, BookedSlotsView, BookSlotView, UpdateSlotStatusView

urlpatterns = [
    path('slots/available/', AvailableSlotsView.as_view(), name='available-slots'),
    path('slots/booked/', BookedSlotsView.as_view(), name='booked-slots'),
    path('slots/book/', BookSlotView.as_view(), name='book-slot'),
    path('slots/update/<int:slot_id>/', UpdateSlotStatusView.as_view(), name='update-slot-status'),
]
