from django.db import models
from django.db.models import F
from django.db import transaction
from django.contrib.auth.models import AbstractUser
from PIL import Image


class User(AbstractUser):
    dob = models.DateField(null=True, blank=True)


class UserProfile(models.Model):
    user = models.OneToOneField(
        User, on_delete=models.CASCADE, related_name='profile')
    followers_count = models.PositiveIntegerField(default=0)
    following_count = models.PositiveIntegerField(default=0)
    profile_picture = models.ImageField(
        default='default.png', upload_to='profile_pics')
    posts_count = models.PositiveIntegerField(default=0)
    is_public = models.BooleanField(default=True)

    def save(self, *args, **kwargs):
        super().save(*args, **kwargs)
        img = Image.open(self.profile_picture.path)
        if img.height > 300 or img.width > 300:
            output_size = (300, 300)
            img.thumbnail(output_size)
            img.save(self.profile_picture.path)

    def __str__(self):
        return '{}'.format(self.user.username)


class Following(models.Model):
    follower = models.ForeignKey(
        User, on_delete=models.CASCADE, related_name='follower')
    followee = models.ForeignKey(
        User, on_delete=models.CASCADE, related_name='followee')

    def add_follower_count(self):
        followee = UserProfile.objects.get(user=self.followee)
        followee.followers_count = F('followers_count') + 1
        followee.save()

    def add_following_count(self):
        follower = UserProfile.objects.get(user=self.follower)
        follower.following_count = F('following_count') + 1
        follower.save()

    def remove_follower_count(self):
        followee = UserProfile.objects.get(user=self.followee)
        followee.followers_count = F('followers_count') - 1
        followee.save()

    def remove_following_count(self):
        follower = UserProfile.objects.get(user=self.follower)
        follower.following_count = F('following_count') - 1
        follower.save()

    def save(self, *args, **kwargs):
        super().save(*args, **kwargs)
        with transaction.atomic():
            self.add_follower_count()
        with transaction.atomic():
            self.add_following_count()

    def delete(self):
        super().delete()
        with transaction.atomic():
            self.remove_follower_count()
        with transaction.atomic():
            self.remove_following_count()

    def __str__(self):
        return self.followee.username + " - Followed By -> " + self.follower.username
