//
//  CheatState.h
//  Mercenary-Rewrite
//
//  Created by Li on 3/20/25.
//

#pragma once

#include <cstdint>

namespace Mercenary
{
    struct CheatState
    {
        bool IsMoveMenu = false;
    };

    inline CheatState& GetState() {
        static CheatState s_State;
        return s_State;
    }
};
