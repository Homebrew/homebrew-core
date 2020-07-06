class SpiceProtocol < Formula
  desc "Headers for SPICE protocol"
  homepage "https://www.spice-space.org/"
  url "https://www.spice-space.org/download/releases/spice-protocol-0.14.2.tar.xz"
  sha256 "8f3a63c8b68300dffe36f2e75eac57afa1e76d5d80af760fd138a0b3f44cf1e9"
  license "BSD-3-Clause"

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
