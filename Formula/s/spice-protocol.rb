class SpiceProtocol < Formula
  desc "Headers for SPICE protocol"
  homepage "https://www.spice-space.org/"
  url "https://www.spice-space.org/download/releases/spice-protocol-0.14.4.tar.xz"
  sha256 "04ffba610d9fd441cfc47dfaa135d70096e60b1046d2119d8db2f8ea0d17d912"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.spice-space.org/download/releases/"
    regex(/href=.*?spice-protocol[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c95213126a4de3d3ab508fbfc7f23f11ece2f0011d3a6d251d7f79034376066e"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <spice/protocol.h>
      int main() {
        return (SPICE_LINK_ERR_OK == 0) ? 0 : 1;
      }
    EOS

    system ENV.cc, "test.cpp", "-I#{include}/spice-1", "-o", "test"
    system "./test"
  end
end
