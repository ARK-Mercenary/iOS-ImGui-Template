//
//  ConfigManager.h
//  Mercenary-Rewrite
//
//  Created by Li on 3/26/25.
//

#pragma once

#import <Foundation/Foundation.h>

#include <string>
#include <cstdint>
#include <vector>

#include "CheatState.h"

class ConfigManager
{
public:
    static ConfigManager& GetInstance() 
    {
        static ConfigManager s_Instance{};
        return s_Instance;
    }

    void SaveState(NSString* cfgName);
    void LoadState(NSString* cfgName);

private:
    NSString* _FilePathForName(NSString* fileName);
    NSArray* _FilesInDirectory(NSString* directoryName, NSString* fileExtension);

    bool _CreateFileWithName(NSString* fileName);
    bool _DeleteFileWithName(NSString* fileName);

    bool _SaveToFileWithName(NSString* fileName, NSData* content);
    bool _LoadFromFileWithName(NSString* fileName, Mercenary::CheatState& state);

private:
	ConfigManager() { }
	~ConfigManager() { }

	ConfigManager(const ConfigManager&) = delete;
	ConfigManager& operator=(const ConfigManager&) = delete;

	ConfigManager(ConfigManager&&) = delete;
	ConfigManager& operator=(ConfigManager&&) = delete;
};
