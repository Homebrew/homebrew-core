class Rist < Formula
  desc "Reliable Internet Stream Transport (RIST)"
  homepage "https://code.videolan.org/rist/"
  url "https://code.videolan.org/rist/librist/-/archive/v0.2.6/librist-v0.2.6.tar.gz"
  sha256 "88b35b86af1ef3d306f33674f2d9511a27d3ff4ec76f20d3a3b3273b79a4521d"
  license "BSD-2-Clause"
  head "https://code.videolan.org/rist/librist.git", branch: "master"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cjson"
  depends_on "cmocka"
  depends_on "mbedtls"

  def install
    mkdir "build"
    system "meson", "build", "."
    system "ninja", "-C", "build"
    bin.mkpath
    bin.install "build/tools/rist2rist"
    bin.install "build/tools/ristreceiver"
    bin.install "build/tools/ristsender"
    bin.install "build/tools/ristsrppasswd"
    lib.mkpath
    lib.install Dir["build/librist*.dylib"]
    inc = include/"librist"
    inc.mkpath
    inc.install "build/include/vcs_version.h"
    inc.install "build/include/librist/version.h"
    inc.install Dir["include/librist/*.h"]
    system "chmod 444 #{include}/librist/*.h"
  end

  test do
    assert_match "Starting ristsender", shell_output("#{bin}/ristsender 2>&1")
  end
end
