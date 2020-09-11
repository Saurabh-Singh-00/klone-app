from django.urls import path, include
from rest_framework_nested import routers
from . import viewsets

user_router = routers.DefaultRouter()
user_router.register('user-profile', viewsets.UserViewSet)

profile_router = routers.NestedSimpleRouter(user_router, 'user-profile', lookup='user')
profile_router.register('profile', viewsets.UserProfileViewSet)

follower_router = routers.NestedSimpleRouter(
    user_router, 'user-profile', lookup='followee')
follower_router.register(
    'follower', viewsets.FollowerViewSet, base_name='follower')

following_router = routers.NestedSimpleRouter(
    user_router, 'user-profile', lookup='follower')
following_router.register(
    'following', viewsets.FollowingViewSet, base_name='followee')

search_router = routers.DefaultRouter()
search_router.register('search', viewsets.SearchViewSet, base_name="search")

urlpatterns = [
    path('', include(user_router.urls)),
    path('', include(profile_router.urls)),
    path('', include(follower_router.urls)),
    path('', include(following_router.urls)),
    path('', include(search_router.urls)),
]
