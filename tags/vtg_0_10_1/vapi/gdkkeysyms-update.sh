cat $1 | sed -e "s/^\\(#define\ GDK_\)\(.*\)\(\ 0x.*\)/\t\[CCode \(cname\=\"GDK_\2\",\ cheader_filename\=\"gdk\/gdkkeysyms.h\"\)\]\n\tpublic\ const\ uint\ Key_\2;/;s/\#define.*//;s/\#if.*/namespace Gdk\n\{/;s/\#endif.*/\n\}/;/^$/d" > gdkkeysyms.vapi 
