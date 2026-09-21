class SpiceServer < Formula
  desc "Implements the server side of the SPICE protocol"
  homepage "https://www.spice-space.org/"
  url "https://gitlab.freedesktop.org/-/project/62/uploads/54a0f9f5d1840e1ad8060cb560f3dde6/spice-0.16.0.tar.bz2"
  sha256 "0a6ec9528f05371261bbb2d46ff35e7b5c45ff89bb975a99af95a5f20ff4717d"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://gitlab.freedesktop.org/spice/spice.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "d4d8192eb6b44f8be4e3a078b632552c96e37babb68bdbd016a4030f2fbb5ef8"
    sha256 cellar: :any, arm64_tahoe:       "369e7eee34a62e07f1453ff10ea53932cd9103d5042f2e3a5cee55dca8aef5ab"
    sha256 cellar: :any, arm64_sequoia:     "e64d2a5ebef5e1548ce96439a4ed62d7914bec80ab3cfb6a37101989a0c89a0c"
    sha256 cellar: :any, arm64_linux:       "0d3712e31816c6d091af1f11aac074dbb6d1cd3d283430f7d568255b2b1ae42c"
    sha256 cellar: :any, x86_64_linux:      "ad95a65263c086fb33453cee6c9452987dc002d85f4b348913eed1f431b00316"
  end

  depends_on "spice-protocol" => [:build, :test]
  depends_on "pkgconf" => :test

  depends_on "glib"
  depends_on "gstreamer"
  depends_on "jpeg-turbo"
  depends_on "lz4"
  depends_on "openssl@3"
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
    flags = shell_output("pkg-config --cflags --libs spice-server").chomp.split
    system ENV.cc, "test.c", *flags, "-o", "test"

    assert_match "Current compat version: 1", shell_output("./test")
  end
end
