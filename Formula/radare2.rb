class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/4.1.1.tar.gz"
  sha256 "b62472601cdd20356b838d6f91738159e30ac1d7b4d0c0cb158575b1ef969e69"
  head "https://github.com/radare/radare2.git"

  bottle do
    sha256 "b29b45ef814bb0366a485a6a592978ca7c3ca2831b4aee7a118fcc36dd8ee401" => :catalina
    sha256 "4efc3612640857a3b5bb2b04aad16a586f43b1ec40bc7660824fac51cddc7fc6" => :mojave
    sha256 "845264fd22164541914cbc22fbccd2cc416afc2b0c230784d073b0f00b33a477" => :high_sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "radare2 #{version}", shell_output("#{bin}/r2 -version")
  end
end
