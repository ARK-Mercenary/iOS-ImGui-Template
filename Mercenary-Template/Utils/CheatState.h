//
//  CheatState.h
//  Mercenary-Rewrite
//
//  Created by Li on 3/20/25.
//

#pragma once

#include <fstream>
#include <string>
#include <cstdint>

namespace Mercenary
{
    struct CheatState
    {
        bool IsMoveMenu;

        CheatState() {
            IsMoveMenu = false;
        }
    };

    inline CheatState& GetState() {
        static CheatState s_State;
        return s_State;
    }
};

namespace ConfigManager
{
    #define ConfigName "UserConfig"
    #define ConfigExtension ".cfg"

    void SaveConfig()
    {
        std::string documentsDirectory = getenv("HOME") + std::string("/Documents");
        std::string filePath = documentsDirectory + "/" + ConfigName + ConfigExtension;

        std::ofstream file(filePath, std::ios::binary);

        if (file.is_open()) {
            const Mercenary::CheatState& state = Mercenary::GetState();
            file.write(reinterpret_cast<const char*>(&state), sizeof(Mercenary::CheatState));
            file.close();
        }
    }

    void LoadConfig()
    {
        std::string documentsDirectory = getenv("HOME") + std::string("/Documents");
        std::string filePath = documentsDirectory + "/" + ConfigName + ConfigExtension;

        std::ifstream file(filePath, std::ios::binary);

        if (file.is_open()) {
            Mercenary::CheatState& state = Mercenary::GetState();
            file.read(reinterpret_cast<char*>(&state), sizeof(Mercenary::CheatState));
            file.close();
        }
    }
};
