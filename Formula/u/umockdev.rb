class Umockdev < Formula
  desc "Mock hardware devices for creating unit tests and bug reporting"
  homepage "https://github.com/martinpitt/umockdev"
  url "https://github.com/martinpitt/umockdev/releases/download/0.19.4/umockdev-0.19.4.tar.xz"
  sha256 "b2014eb0835be508ddf0cdbdd682e33b3daefa6aab5b24c5b326f46f9db8706d"
  license "LGPL-2.1-or-later"
  head "https://github.com/martinpitt/umockdev.git", branch: "main"

  bottle do
    sha256 arm64_linux:  "d66cee53f5ef75b4bfecf01ec8d43ae6302be991c58988b9df529f550228e28a"
    sha256 x86_64_linux: "28b1b390f3ce079526b9c7c25551fc9c758a5e50db29d70e6ae34c52f947b3d5"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "glib"
  depends_on "libpcap"
  depends_on :linux
  depends_on "systemd"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # https://github.com/martinpitt/umockdev/blob/main/tests/test-umockdev.c
    (testpath/"test.c").write <<~C
      #include <glib.h>
      #include <libudev.h>
      #include <umockdev.h>

      int main() {
        gchar *attributes[] = { "idVendor", "0815", "idProduct", "AFFE", NULL };
        gchar *properties[] = { "ID_INPUT", "1", "ID_INPUT_KEYBOARD", "1", NULL };
        UMockdevTestbed *testbed;
        struct udev *udev;
        struct udev_monitor *udev_mon;
        struct udev_device *device;

        testbed = umockdev_testbed_new();
        g_assert(testbed != NULL);
        udev = udev_new();
        g_assert(udev != NULL);
        udev_mon = udev_monitor_new_from_netlink(udev, "udev");
        g_assert(udev_mon != NULL);
        g_assert_cmpint(udev_monitor_get_fd(udev_mon), >, 0);
        g_assert_cmpint(udev_monitor_enable_receiving(udev_mon), ==, 0);

        g_autofree gchar *syspath = umockdev_testbed_add_devicev(testbed, "usb", "extkeyboard1",
                                                                 NULL, attributes, properties);
        g_assert_cmpstr(syspath, ==, "/sys/devices/extkeyboard1");

        device = udev_monitor_receive_device(udev_mon);
        g_assert(device != NULL);
        g_assert_cmpstr(udev_device_get_syspath(device), ==, syspath);
        g_assert_cmpstr(udev_device_get_action(device), ==, "add");

        udev_device_unref(device);
        udev_monitor_unref(udev_mon);
        udev_unref(udev);
        g_object_unref(testbed);
        return 0;
      }
    C

    ENV.append_path "PKG_CONFIG_PATH", Formula["systemd"].lib/"pkgconfig" if OS.linux?
    flags = shell_output("pkgconf --cflags --libs umockdev-1.0 libudev").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system bin/"umockdev-wrapper", testpath/"test"
  end
end
