from django.urls import path
from .views import SignupView, LoginView, UserDetailsView, ChangePasswordView, ForgotPasswordView, LogoutView

urlpatterns = [
    path('signup/', SignupView.as_view(), name='signup'),
    path('login/', LoginView.as_view(), name='login'),
    path('user/', UserDetailsView.as_view(), name='user-details'),
    path('change-password/', ChangePasswordView.as_view(), name='change-password'),
    path('forgot-password/', ForgotPasswordView.as_view(), name='forgot-password'),
    path('logout/', LogoutView.as_view(), name='logout'),

]
