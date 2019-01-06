class SpiceProtocol < Formula
  desc "Headers for SPICE protocol"
  homepage "https://www.spice-space.org/"
  url "https://www.spice-space.org/download/releases/spice-protocol-0.12.14.tar.bz2"
  sha256 "20350bc4309039fdf0d29ee4fd0033cde27bccf33501e13b3c1befafde9d0c9c"

  bottle do
    cellar :any_skip_relocation
    sha256 "1240657df2775e902ca34294b48e4163ba0abdbacec45bd5e4c1f19829f362b0" => :mojave
    sha256 "9b9013afafa2d15479d49e2c5397321d287fa9861754f3aab232b33112d3b081" => :high_sierra
    sha256 "9b9013afafa2d15479d49e2c5397321d287fa9861754f3aab232b33112d3b081" => :sierra
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
