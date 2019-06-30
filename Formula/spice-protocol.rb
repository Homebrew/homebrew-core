class SpiceProtocol < Formula
  desc "Headers for SPICE protocol"
  homepage "https://www.spice-space.org/"
  url "https://www.spice-space.org/download/releases/spice-protocol-0.14.0.tar.bz2"
  sha256 "b6a4aa1ca32668790b45a494bbd000e9d05797b391d5a5d4b91adf1118216eac"

  bottle do
    cellar :any_skip_relocation
    sha256 "58938d9e32325c87b6b1f9d32cfe3129c5aa15de719f48aa69e83b1ab1e9af06" => :mojave
    sha256 "58938d9e32325c87b6b1f9d32cfe3129c5aa15de719f48aa69e83b1ab1e9af06" => :high_sierra
    sha256 "f24ec0961c7927c406ff0e86ee78be7c94f7269e0ff0d3c0839136fa43cf03e2" => :sierra
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
