/******************************************************************************
**  libDXFrw - Library to read/write DXF files (ascii & binary)              **
**                                                                           **
**  Copyright (C) 2011-2015 José F. Soriano, rallazz@gmail.com               **
**                                                                           **
**  This library is free software, licensed under the terms of the GNU       **
**  General Public License as published by the Free Software Foundation,     **
**  either version 2 of the License, or (at your option) any later version.  **
**  You should have received a copy of the GNU General Public License        **
**  along with this program.  If not, see <http://www.gnu.org/licenses/>.    **
******************************************************************************/

#include "drw_base.h"
#include "intern/drw_dbg.h"

void DRW::setCustomDebugPrinter(DebugPrinter *printer)
{
  DRW_dbg::getInstance()->setCustomDebugPrinter(std::unique_ptr<DebugPrinter>(printer));
}

DRW::DebugPrinter::~DebugPrinter() = default;

const std::unordered_map< const char*, DRW::Version > DRW_Versions::dwgVersionStrings {
    { "MC0.0", DRW::Version::MC00 },
    { "AC1.2", DRW::Version::AC12 },
    { "AC1.4", DRW::Version::AC14 },
    { "AC1.50", DRW::Version::AC150 },
    { "AC2.10", DRW::Version::AC210 },
    { "AC1002", DRW::Version::AC1002 },
    { "AC1003", DRW::Version::AC1003 },
    { "AC1004", DRW::Version::AC1004 },
    { "AC1006", DRW::Version::AC1006 },
    { "AC1009", DRW::Version::AC1009 },
    { "AC1012", DRW::Version::AC1012 },
    { "AC1014", DRW::Version::AC1014 },
    { "AC1015", DRW::Version::AC1015 },
    { "AC1018", DRW::Version::AC1018 },
    { "AC1021", DRW::Version::AC1021 },
    { "AC1024", DRW::Version::AC1024 },
    { "AC1027", DRW::Version::AC1027 },
    { "AC1032", DRW::Version::AC1032 },
};
