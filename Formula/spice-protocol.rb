class SpiceProtocol < Formula
  desc "Headers for SPICE protocol"
  homepage "https://www.spice-space.org/"
  url "https://www.spice-space.org/download/releases/spice-protocol-0.14.3.tar.xz"
  sha256 "f986e5bc2a1598532c4897f889afb0df9257ac21c160c083703ae7c8de99487a"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.spice-space.org/download/releases/"
    regex(/href=.*?spice-protocol[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "1f1d09e0fdcd095c950b1f1568133b15dd8cd7c752463cdfaf6ff9343895b8d3" => :big_sur
    sha256 "fd26340728c429bf9986173e7bc5c8096158e14a03b52c19357b6d1e7eb4ffb5" => :arm64_big_sur
    sha256 "c1e7d23c49491707d0113d45759756a55fb479ed0cdc6c0d3ec55d68a58a61cd" => :catalina
    sha256 "c65655047ff18f1b00ec71a24469409c4483f0be190fdc2735470730cdf95b17" => :mojave
    sha256 "86145a5c7d8c109671fb9277ac07c56c8f8475c0854b2e2123a3beabd2626f06" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Dwith-docs=false", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <spice/protocol.h>
      int main() {
        return (SPICE_LINK_ERR_OK == 0) ? 0 : 1;
      }
    EOS
    system ENV.cc, "test.cpp",
                   "-I#{include}/spice-1",
                   "-o", "test"
    system "./test"
  end
end
