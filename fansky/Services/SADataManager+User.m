//
//  SADataManager+User.m
//  fansky
//
//  Created by Zzy on 9/10/15.
//  Copyright (c) 2015 Zzy. All rights reserved.
//

#import "SADataManager+User.h"
#import "SAUser+CoreDataProperties.h"

@implementation SADataManager (User)

static NSString *const ENTITY_NAME = @"SAUser";

- (SAUser *)currentUser
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:ENTITY_NAME];
    fetchRequest.fetchLimit = 1;
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"isActive = %@", @(YES)];
    
    __block NSError *error;
    __block SAUser *resultUser;
    [self.managedObjectContext performBlockAndWait:^{
        NSArray *fetchResult = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (!error && fetchResult && fetchResult.count) {
            SAUser *existUser = [fetchResult firstObject];
            resultUser = existUser;
        }
    }];
    return resultUser;
}

- (SAUser *)insertOrUpdateUserWithObject:(id)userObject local:(BOOL)local active:(BOOL)active token:(NSString *)token secret:(NSString *)secret
{
    NSString *userID = (NSString *)[userObject objectForKey:@"id"];
    NSString *name = (NSString *)[userObject objectForKey:@"name"];
    NSString *location = (NSString *)[userObject objectForKey:@"location"];
    NSString *desc = (NSString *)[userObject objectForKey:@"description"];
    NSString *profileImageURL = (NSString *)[userObject objectForKey:@"profile_image_url_large"];
    NSNumber *isFollowing = [userObject objectForKey:@"following"];
    NSNumber *friendsCount = [userObject objectForKey:@"friends_count"];
    NSNumber *followersCount = [userObject objectForKey:@"followers_count"];
    NSNumber *statusCount = [userObject objectForKey:@"statuses_count"];
    NSNumber *isProtected = [userObject objectForKey:@"protected"];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:ENTITY_NAME];
    fetchRequest.fetchLimit = 1;
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"userID = %@", userID];
    
    __block NSError *error;
    __block SAUser *resultUser;
    [self.managedObjectContext performBlockAndWait:^{
        NSArray *fetchResult = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (!error && fetchResult && fetchResult.count) {
            SAUser *existUser = [fetchResult firstObject];
            existUser.name = name;
            existUser.location = location;
            existUser.desc = desc;
            existUser.profileImageURL = profileImageURL;
            existUser.isFollowing = isFollowing;
            existUser.friendsCount = friendsCount;
            existUser.followersCount = followersCount;
            existUser.statusCount = statusCount;
            existUser.isProtected = isProtected;
            if (local) {
                existUser.isLocal = @(local);
                existUser.isActive = @(active);
                existUser.token = token;
                existUser.tokenSecret = secret;
            }
            resultUser = existUser;
        } else {
            [self.managedObjectContext performBlockAndWait:^{
                SAUser *user = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_NAME inManagedObjectContext:self.managedObjectContext];
                user.userID = userID;
                user.name = name;
                user.location = location;
                user.desc = desc;
                user.profileImageURL = profileImageURL;
                user.isFollowing = isFollowing;
                user.friendsCount = friendsCount;
                user.followersCount = followersCount;
                user.statusCount = statusCount;
                user.isProtected = isProtected;
                if (local) {
                    user.isLocal = @(local);
                    user.isActive = @(active);
                    user.token = token;
                    user.tokenSecret = secret;
                }
                resultUser = user;
            }];
        }
    }];
    return resultUser;
}

- (SAUser *)userWithID:(NSString *)userID
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:ENTITY_NAME];
    fetchRequest.fetchLimit = 1;
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"userID = %@", userID];
    
    __block NSError *error;
    __block SAUser *resultUser;
    [self.managedObjectContext performBlockAndWait:^{
        NSArray *fetchResult = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (!error && fetchResult && fetchResult.count) {
            SAUser *existUser = [fetchResult firstObject];
            resultUser = existUser;
        }
    }];
    return resultUser;
}

- (SAUser *)userWithObject:(id)object
{
    NSString *userID = (NSString *)[object objectForKey:@"id"];
    NSString *name = (NSString *)[object objectForKey:@"name"];
    NSString *location = (NSString *)[object objectForKey:@"location"];
    NSString *profileImageURL = (NSString *)[object objectForKey:@"profile_image_url_large"];
    NSNumber *isFollowing = [object objectForKey:@"following"];
    NSNumber *friendsCount = [object objectForKey:@"friends_count"];
    NSNumber *followersCount = [object objectForKey:@"followers_count"];
    NSNumber *statusCount = [object objectForKey:@"statuses_count"];
    NSNumber *isProtected = [object objectForKey:@"protected"];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:ENTITY_NAME inManagedObjectContext:self.managedObjectContext];
    SAUser *user = [[SAUser alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:nil];
    user.userID = userID;
    user.name = name;
    user.location = location;
    user.profileImageURL = profileImageURL;
    user.isFollowing = isFollowing;
    user.friendsCount = friendsCount;
    user.followersCount = followersCount;
    user.statusCount = statusCount;
    user.isProtected = isProtected;
    return user;
}

- (void)setCurrentUserWithUserID:(NSString *)userID
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:ENTITY_NAME];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"isLocal = %@", @(YES)];
    
    __block NSError *error;
    [self.managedObjectContext performBlockAndWait:^{
        NSArray *fetchResult = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (!error && fetchResult && fetchResult.count) {
            [fetchResult enumerateObjectsUsingBlock:^(SAUser *user, NSUInteger idx, BOOL *stop) {
                if (user.userID == userID) {
                    user.isActive = @(YES);
                } else {
                    user.isActive = @(NO);
                }
            }];
        }
    }];
}

- (void)deleteUserWithUserID:(NSString *)userID
{
    SAUser *user = [self userWithID:userID];
    user.isLocal = @(NO);
    user.isActive = @(NO);
}

@end
