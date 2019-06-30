class SpiceProtocol < Formula
  desc "Headers for SPICE protocol"
  homepage "https://www.spice-space.org/"
  url "https://www.spice-space.org/download/releases/spice-protocol-0.14.0.tar.bz2"
  sha256 "b6a4aa1ca32668790b45a494bbd000e9d05797b391d5a5d4b91adf1118216eac"

  bottle do
    cellar :any_skip_relocation
    sha256 "b899ebffaf616bb0801dd3ad1b0f87b9b05b756257875a3311534c4408aecc08" => :mojave
    sha256 "0d946742733d9edd6fcb9c2b6ca5c50dda97655cec7e1baa4f4032875e4eed4e" => :high_sierra
    sha256 "0d946742733d9edd6fcb9c2b6ca5c50dda97655cec7e1baa4f4032875e4eed4e" => :sierra
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
