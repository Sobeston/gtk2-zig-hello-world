const std = @import("std");
const c = @cImport(@cInclude("gtk/gtk.h"));

pub fn main() !void {
    c.gtk_init(null, null);
    const window = c.gtk_window_new(.GTK_WINDOW_TOPLEVEL);
    const button = c.gtk_button_new();
    const label = c.gtk_label_new("Hello World");

    c.gtk_container_add(@ptrCast(*c.GtkContainer, button), label);
    c.gtk_container_add(@ptrCast(*c.GtkContainer, window), button);

    c.gtk_window_set_title(@ptrCast(*c.GtkWindow, window), "testing program");
    c.gtk_container_set_border_width(@ptrCast(*c.GtkContainer, button), 10);
    c.gtk_window_set_default_size(@ptrCast(*c.GtkWindow, window), 400, 400);

    _ = c.gtk_signal_connect_full(
        @ptrCast(*c.GtkObject, window),
        "delete_event",
        @ptrCast(c.GCallback, struct {
            fn f(w: *c.GtkWidget, event: *c.GdkEventAny, data: c.gpointer) c.gint {
                c.gtk_main_quit();
                return 0;
            }
        }.f),
        null,
        label,
        null,
        0,
        0,
    );

    _ = c.gtk_signal_connect_full(
        @ptrCast(*c.GtkObject, button),
        "clicked",
        @ptrCast(c.GCallback, struct {
            fn f(_: *c.GtkWidget, data: c.gpointer) void {
                const lbl = @ptrCast(*c.GtkWidget, @alignCast(@alignOf(c.GtkWidget), data));
                var text: [*c]c.gchar = undefined;
                c.gtk_label_get(@ptrCast(*c.GtkLabel, lbl), &text);
                std.debug.print("{s}\n", .{text});
            }
        }.f),
        null,
        label,
        null,
        0,
        0,
    );

    c.gtk_widget_show_all(window);
    c.gtk_main();
}