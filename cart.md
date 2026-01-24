# Picotron Wiki Cartridge

## Information

This is a cartridge making use of the pod form of the wiki's database.

There are some known issues as listed below

## Download

This can be found on the [Lexaloffle BBS](https://www.lexaloffle.com/bbs/?tid=154532)
or downloaded with:
```
load #wiki -u
save /where/to/store/the/wiki/cart.p64
```

## Credits

Development - Astralsparv
Lilwide font - thelxinoe5

## To Do / Issues

You cannot click links

Text wrapping is based on characters rather than words

Text wrapping doesn't seem to be using the full width that is given

Some markdown formatting isn't correct (I think this comes from the pod db treating the md codeblock headers as real headers, seen in `documenting.md`)

Custom themes:

* Colors
* Fonts

There's no variation between headers, they are all lilwide.

Codeblocks aren't proper codeblocks nor do they have syntax - likely that they'll have to be handled seperately to normal prints.