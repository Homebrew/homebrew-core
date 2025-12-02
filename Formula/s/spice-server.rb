class SpiceServer < Formula
  desc "Implements the server side of the SPICE protocol"
  homepage "https://www.spice-space.org/"
  url "https://gitlab.freedesktop.org/-/project/62/uploads/54a0f9f5d1840e1ad8060cb560f3dde6/spice-0.16.0.tar.bz2"
  sha256 "0a6ec9528f05371261bbb2d46ff35e7b5c45ff89bb975a99af95a5f20ff4717d"
  license "LGPL-2.1-or-later"
  head "https://gitlab.freedesktop.org/spice/spice.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3d4a9ac58d3fefbd7d4ff3b286623cabb0573dbee26ecc258c63ac2c4857c623"
    sha256 cellar: :any,                 arm64_sequoia: "600da87f0215eb7a409047dafcda30bf99509ed4f52c1adc463e5f5169c29d87"
    sha256 cellar: :any,                 arm64_sonoma:  "c25f2bb724d33169028e41b409c230030aa2efc7ea95af9ddd52f5c3bbdf4b4b"
    sha256 cellar: :any,                 arm64_ventura: "027a196515564119dae4fcc9ce048890ce71f1f947904cc1b3a96f6ba82b4086"
    sha256 cellar: :any,                 sonoma:        "1f1413376cdd65d268fd79dbc130f24b8a6fca760a98734bc7c2bb016e0c64a8"
    sha256 cellar: :any,                 ventura:       "959df8679b8553cc1b5d700f374e5f3be12ac4b7928cb977aff4f65f8fc4a768"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18e8ad43cb6cb02a62beffeef8010f0187733862ef9ed53edb6a18affa06ce71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8689579c9750ad3907b15c94f46b758b6eac7dcc38384e5606585036e0ef6172"
  end

  depends_on "spice-protocol" => [:build, :test]
  depends_on "pkgconf" => :test

  depends_on "glib"
  depends_on "gstreamer"
  depends_on "jpeg"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "opus"
  depends_on "orc"
  depends_on "pixman"

  uses_from_macos "cyrus-sasl"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "systemd"
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
