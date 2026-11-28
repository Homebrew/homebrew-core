class Umockdev < Formula
  desc "Mock hardware devices for creating unit tests and bug reporting"
  homepage "https://launchpad.net/umockdev"
  url "https://github.com/martinpitt/umockdev/releases/download/0.20.0/umockdev-0.20.0.tar.xz"
  sha256 "c6ea246c457d29d5892c6622bf4812737aee975153497f3462c572e61b0404be"
  license "LGPL-2.1-or-later"
  compatibility_version 1
  head "https://github.com/martinpitt/umockdev.git", branch: "main"

  bottle do
    manifest_sha256 "9b000b1d6b0e4e6fd1008f47ba45989d09f57ae86905279018443b6388adcd66"
    sha256 cellar: :any, arm64_linux:  "9a3cd07daa15874b01b833701f43c7627a04b303fd1998ff4833d0b917a11461"
    sha256 cellar: :any, x86_64_linux: "b5f457cfb7fa6feebee62df0ec42300790aa3fdb2376cd3262266a9aa0356a64"
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

  deny_network_access!

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

    ENV.append_path "PKG_CONFIG_PATH", formula_opt_lib("systemd")/"pkgconfig" if OS.linux?
    flags = shell_output("pkgconf --cflags --libs umockdev-1.0 libudev").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system bin/"umockdev-wrapper", testpath/"test"
  end
end
