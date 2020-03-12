class SpiceProtocol < Formula
  desc "Headers for SPICE protocol"
  homepage "https://www.spice-space.org/"
  url "https://www.spice-space.org/download/releases/spice-protocol-0.14.1.tar.bz2"
  sha256 "79e6da61834b080a143234c1cd4c099a8ead1a64b5039489610b72ab282c132a"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac166e2e8a89dfa451a4abe531b31430fb6c3f5b386cf92f39b1a518837ff0ac" => :catalina
    sha256 "ac166e2e8a89dfa451a4abe531b31430fb6c3f5b386cf92f39b1a518837ff0ac" => :mojave
    sha256 "ac166e2e8a89dfa451a4abe531b31430fb6c3f5b386cf92f39b1a518837ff0ac" => :high_sierra
  end

  def install
    system "./configure", "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
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
