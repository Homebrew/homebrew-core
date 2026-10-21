class SpiceServer < Formula
  desc "Implements the server side of the SPICE protocol"
  homepage "https://www.spice-space.org/"
  url "https://gitlab.freedesktop.org/-/project/62/uploads/54a0f9f5d1840e1ad8060cb560f3dde6/spice-0.16.0.tar.bz2"
  sha256 "0a6ec9528f05371261bbb2d46ff35e7b5c45ff89bb975a99af95a5f20ff4717d"
  license "LGPL-2.1-or-later"
  revision 2
  head "https://gitlab.freedesktop.org/spice/spice.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ee519d2b1a6707336149094a3c67985f2645c917af937939db333cd21a3b9c1e"
    sha256 cellar: :any, arm64_tahoe:       "208555b9383d1016fde6343e6b92d2b5ca89928b7d743675198f921566cebc43"
    sha256 cellar: :any, arm64_sequoia:     "853367dd10048ed383c9a3544996ff80d40988f19d5312de43d60d628fa3eaac"
    sha256 cellar: :any, arm64_linux:       "687aa0dc9759407b83f0f256cacbf1b4806c706c955aa1ddca9aee97fb9924cf"
    sha256 cellar: :any, x86_64_linux:      "aaca9b5de28152a0cb015cddd822fcdc1943372713b968399b7bd7b3c0b8bd8b"
  end

  depends_on "spice-protocol" => [:build, :test]
  depends_on "pkgconf" => :test

  depends_on "glib"
  depends_on "gstreamer"
  depends_on "jpeg-turbo"
  depends_on "lz4"
  depends_on "openssl@4"
  depends_on "opus"
  depends_on "orc"
  depends_on "pixman"

  uses_from_macos "cyrus-sasl"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "systemd"
    depends_on "zlib-ng-compat"
  end

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
    ]
    # Avoid running gst-inspect-1.0 which stalls in macOS sandbox.
    # GStreamer is still enabled when checks cannot run.
    args << "ac_cv_path_GST_INSPECT_1_0=" if OS.mac?

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include "spice.h"
      int main() {
          spice_compat_version_t current_compat_version = spice_get_current_compat_version();
          printf("Current compat version: %d\\n", current_compat_version);
          return 0;
      }
    C

    ENV.prepend_path "PKG_CONFIG_PATH", formula_opt_lib("openssl@4")/"pkgconfig"
    flags = shell_output("pkg-config --cflags --libs spice-server").chomp.split
    system ENV.cc, "test.c", *flags, "-o", "test"

    assert_match "Current compat version: 1", shell_output("./test")
  end
end
