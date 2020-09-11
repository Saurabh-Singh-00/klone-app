from django.db.models import Q
from rest_framework import viewsets, permissions
from . import serializers
from user import models
from rest_framework.renderers import JSONRenderer
from rest_framework.parsers import JSONParser


class UserViewSet(viewsets.ModelViewSet):
    serializer_class = serializers.UserSerializer
    queryset = models.User.objects.all()
    permission_classes = [permissions.IsAuthenticated, ]


class UserProfileViewSet(viewsets.ModelViewSet):
    serializer_class = serializers.UserProfileSerializer
    queryset = models.UserProfile.objects.all()
    permission_classes = [permissions.IsAuthenticatedOrReadOnly, ]


class FollowerViewSet(viewsets.ModelViewSet):
    serializer_class = serializers.FollowerSerializer

    def get_queryset(self):
        return models.Following.objects.filter(
            followee__pk=self.kwargs['followee_pk'])


class FollowingViewSet(viewsets.ReadOnlyModelViewSet):
    serializer_class = serializers.FollowingSerializer

    def get_queryset(self):
        f = models.Following.objects.filter(
            follower__pk=self.kwargs['follower_pk'])
        return f


class SearchViewSet(viewsets.ModelViewSet):
    serializer_class = serializers.SearchSerializer
    permission_classes = [permissions.IsAuthenticatedOrReadOnly]

    def get_queryset(self, *args, **kwargs):
        user_list = []
        query = self.request.GET.get("user")
        if query:
            user_list = models.User.objects.filter(Q(first_name__icontains=query) | Q(
                last_name__icontains=query) | Q(username__icontains=query)).exclude(username=self.request.user.username).distinct()
        return user_list
