# width_rel

## Overview

Overwrites [`Element.width`](/picotron_api/gui/attributes/width/main.md) - if you want finer control over the final width, use [`Element.width_add`](/picotron_api/gui/attributes/width_add/main.md) or [`Element.min_width`](/picotron_api/gui/attributes/min_width/main.md).

## Values

Default value: nil

Valid values: nil, number between 0 and 1

If not nil, automatically adjusts element width based on [`parent.width`](/picotron_api/gui/attributes/width/main.md) as a decimal (the percentage / 100)

e.g:
* 1 = 100% of the parent width
* 0.5 means 50%