# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2020 Rother OSS GmbH, https://otobo.de/
# --
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
# --

use strict;
use warnings;
use utf8;

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;
use Kernel::System::UnitTest::MockTime qw(:all);

use vars (qw($Self));

# get time object
my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

my $StartSystemTime = $TimeObject->SystemTime();

{
    my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

    sleep 1;

    my $FixedTime = FixedTimeSet();

    sleep 1;

    $Self->Is(
        $TimeObject->SystemTime(),
        $FixedTime,
        "Stay with fixed time",
    );

    sleep 1;

    $Self->Is(
        $TimeObject->SystemTime(),
        $FixedTime,
        "Stay with fixed time",
    );

    FixedTimeAddSeconds(-10);

    $Self->Is(
        $TimeObject->SystemTime(),
        $FixedTime - 10,
        "Stay with increased fixed time",
    );

    FixedTimeUnset();

    # Let object be destroyed at the end of this scope
    $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::UnitTest::Helper'] );
}

sleep 1;

$Self->True(
    $TimeObject->SystemTime() >= $StartSystemTime,
    "Back to original time",
);


$Self->DoneTesting();


