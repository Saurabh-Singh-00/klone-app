from django.urls import path, include
from rest_framework_nested import routers
from . import viewsets
from user.api import urls as user_urls

post_router = routers.NestedSimpleRouter(
    user_urls.user_router, 'user-profile', lookup='user')
post_router.register('post', viewsets.PostViewSet)

explore_router = routers.NestedSimpleRouter(
    user_urls.user_router, 'user-profile', lookup='user')
explore_router.register('explore', viewsets.ExploreViewSet, base_name='explore')

feed_router = routers.NestedSimpleRouter(
    user_urls.user_router, 'user-profile', lookup='user')
feed_router.register('feed', viewsets.FeedsViewSet, 'feed')

comment_router = routers.NestedSimpleRouter(post_router, 'post', lookup='post')
comment_router.register(
    'comment', viewsets.CommentViewSet, base_name='comment')

like_router = routers.NestedSimpleRouter(post_router, 'post', lookup='post')
like_router.register('like', viewsets.LikeViewSet, base_name='like')

userlike_router = routers.NestedSimpleRouter(
    user_urls.user_router, 'user-profile', lookup='user')
userlike_router.register('like', viewsets.UserLikeViewSet, base_name='like')


urlpatterns = [
    path('', include(post_router.urls)),
    path('', include(feed_router.urls)),
    path('', include(comment_router.urls)),
    path('', include(like_router.urls)),
    path('', include(userlike_router.urls)),
    path('', include(explore_router.urls)),
]
