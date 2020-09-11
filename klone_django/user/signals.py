from django.db.models.signals import post_save, pre_save
from django.dispatch import receiver
from user.models import User, UserProfile, Following


@receiver(post_save, sender=User)
def create_user_profile(sender, instance, created, **kwargs):
    if created:
        UserProfile.objects.create(user=instance)


@receiver(post_save, sender=User)
def save_profile(sender, instance, **kwargs):
    instance.profile.save()
