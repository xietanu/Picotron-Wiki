# height_rel

## Overview

Overwrites [`Element.height`](/picotron_api/gui/attributes/height/main.md) - if you want finer control over the final height, use [`Element.height_add`](/picotron_api/gui/attributes/height_add/main.md) or [`Element.min_height`](/picotron_api/gui/attributes/min_height/main.md).

## Values

Default value: nil

Valid values: nil, number between 0 and 1

If not nil, automatically adjusts element height based on [`parent.height`](/picotron_api/gui/attributes/height/main.md) as a decimal (the percentage / 100)

e.g:
* 1 = 100% of the parent height
* 0.5 means 50%