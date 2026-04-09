class SpiceServer < Formula
  desc "Implements the server side of the SPICE protocol"
  homepage "https://www.spice-space.org/"
  url "https://gitlab.freedesktop.org/-/project/62/uploads/54a0f9f5d1840e1ad8060cb560f3dde6/spice-0.16.0.tar.bz2"
  sha256 "0a6ec9528f05371261bbb2d46ff35e7b5c45ff89bb975a99af95a5f20ff4717d"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://gitlab.freedesktop.org/spice/spice.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "07095428a0e9637309224c9dc6302a91caa37e2b22f8a678bf5c2a21d250b7ee"
    sha256 cellar: :any,                 arm64_sequoia: "0f9f963c11eb9ee7b46b8a0bbf09d6bf41c5aed8f9efee35bfd8f79876c3fc48"
    sha256 cellar: :any,                 arm64_sonoma:  "ca403a88aa347d491f11d11a909293a90ac40253200cadc91c6ec6f62e3a628e"
    sha256 cellar: :any,                 sonoma:        "222e8fd73393fb53e9b48f137d4d68abc5be1c7d99dfdeb54f430ac31af2c2a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "896f8baf333c39adb63fc0e59a7169a09e2b667d992d1d0ae305cdfa1703ecb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5a261c1f9a99a02795a3530791493d4992ca792c5f9ba30204149b47a0701df"
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
