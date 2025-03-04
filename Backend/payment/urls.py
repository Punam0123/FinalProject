from django.urls import path
from .views import CreatePaymentView, ProcessPaymentView, PaymentStatusView

urlpatterns = [
    path("create/", CreatePaymentView.as_view(), name="create-payment"),  # Create Payment
    path("process/<uuid:payment_id>/", ProcessPaymentView.as_view(), name="process-payment"),  # Process Payment
    path("status/<uuid:payment_id>/", PaymentStatusView.as_view(), name="payment-status"),  # Check Payment Status
]
