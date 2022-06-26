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

  on_linux do
    # Test fails on gcc-5: spice/macros.h:68:32: error: expected '}' before '__attribute__'
    depends_on "gcc" => :test
  end

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
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

    cc = if OS.mac?
      ENV.cc
    else
      Formula["gcc"].opt_bin/"gcc-#{Formula["gcc"].any_installed_version.major}"
    end

    system cc, "test.cpp", "-I#{include}/spice-1", "-o", "test"
    system "./test"
  end
end
