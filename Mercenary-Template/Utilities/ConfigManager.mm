//
//  ConfigManager.mm
//  Mercenary-Rewrite
//
//  Created by Li on 3/26/25.
//

#include "ConfigManager.h"
#include "../ImGui/imgui.h"

void ConfigManager::SaveState(NSString* cfgName)
{
    NSString* filePath = _FilePathForName(cfgName);
    NSData* settings = [NSData dataWithBytes:&Mercenary::GetState() length:sizeof(Mercenary::GetState())];

    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        NSData* oldSettings = [NSData dataWithContentsOfFile:filePath];

        if (![oldSettings isEqualToData:settings]) // checks to see if settings have changed before saving
        {
            //NSLog(@"[class ConfigManager]: File exists at %@. Saving new settings", filePath);
            _SaveToFileWithName(cfgName, settings);
        }
        return;
    }

    //NSLog(@"[class ConfigManager]: File doesn't exist. Creating new file at %@", filePath);
    _CreateFileWithName(cfgName);
    return;
}

void ConfigManager::LoadState(NSString* cfgName)
{
    NSString* filePath = _FilePathForName(cfgName);
    static Mercenary::CheatState& state = Mercenary::GetState();

    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        //NSLog(@"[class ConfigManager]: File exists at %@. Loading new settings", filePath);
        _LoadFromFileWithName(cfgName, state);
        return;
    }

    //NSLog(@"[class ConfigManager]: File doesn't exist. Creating new file at %@", filePath);
    _CreateFileWithName(cfgName);
    return;
}

bool ConfigManager::_CreateFileWithName(NSString* fileName)
{
    NSString* filePath = _FilePathForName(fileName);

    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        //NSLog(@"[class ConfigManager]: File already exists at path: %@", filePath);
        return false;
    }

    //NSLog(@"[class ConfigManager]: Successfully created file at path: %@", filePath);
    return [[NSFileManager defaultManager] createFileAtPath:filePath contents:[NSData data] attributes:nil];
}

bool ConfigManager::_DeleteFileWithName(NSString* fileName)
{
    NSString* filePath = _FilePathForName(fileName);
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        //NSLog(@"[class ConfigManager]: Successfully deleted file at path: %@", filePath);
        return [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }

    //NSLog(@"[class ConfigManager]: File does not exist at path: %@", filePath);
    return false;
}

bool ConfigManager::_SaveToFileWithName(NSString* fileName, NSData* content)
{
    NSString* filePath = _FilePathForName(fileName);
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        //NSLog(@"[class ConfigManager]: Successfully saved contents to file at path: %@", filePath);
        return [content writeToFile:filePath options:NSDataWritingAtomic error:nil];
    }

    return false;
}

bool ConfigManager::_LoadFromFileWithName(NSString* fileName, Mercenary::CheatState& state)
{
    NSString* filePath = _FilePathForName(fileName);
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        //NSLog(@"[class ConfigManager]: Successfully loaded contents from file at path: %@", filePath);
        NSData* settings = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:nil];
        [settings getBytes:&state length:sizeof(state)]; // copies raw data from file
        return true;
    }

    return false;
}

NSString* ConfigManager::_FilePathForName(NSString* fileName)
{
    NSString* documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

NSArray* ConfigManager::_FilesInDirectory(NSString* directoryName, NSString* fileExtension)
{    
    NSArray* files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryName error:nil];
    
    NSMutableArray* foundFiles = [NSMutableArray array];
    for (NSString* file in files) {
        if ([file hasSuffix:fileExtension]) {
            [foundFiles addObject:file];
        }
    }
    
    return foundFiles;
}
