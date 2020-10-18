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
    sha256 "e1ade135b57cc78000d754e20b86ac2ce39f3a6bb466095995cc1dd1b57f7e96" => :catalina
    sha256 "e1ade135b57cc78000d754e20b86ac2ce39f3a6bb466095995cc1dd1b57f7e96" => :mojave
    sha256 "e1ade135b57cc78000d754e20b86ac2ce39f3a6bb466095995cc1dd1b57f7e96" => :high_sierra
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
