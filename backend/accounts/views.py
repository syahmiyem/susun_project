# accounts/views.py
from django.contrib.auth import authenticate
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.authtoken.models import Token
from rest_framework.permissions import IsAuthenticated

class LoginView(APIView):
    # Disable authentication for the login endpoint
    authentication_classes = []
    permission_classes = []

    def post(self, request):
        # Extract username and password from request data
        username = request.data.get("username")
        password = request.data.get("password")
        if not username or not password:
            return Response(
                {"error": "Username and password are required."},
                status=status.HTTP_400_BAD_REQUEST
            )
        user = authenticate(username=username, password=password)
        if user is not None:
            # Generate or retrieve an existing token for the user
            token, created = Token.objects.get_or_create(user=user)
            return Response({"token": token.key}, status=status.HTTP_200_OK)
        return Response(
            {"error": "Invalid credentials."},
            status=status.HTTP_400_BAD_REQUEST
        )

class LogoutView(APIView):
    # Only authenticated users can log out
    permission_classes = [IsAuthenticated]

    def post(self, request):
        try:
            # Delete the token to log the user out
            request.user.auth_token.delete()
            return Response({"message": "Successfully logged out."}, status=status.HTTP_200_OK)
        except Exception as e:
            return Response(
                {"error": f"Logout failed: {str(e)}"},
                status=status.HTTP_400_BAD_REQUEST
            )
