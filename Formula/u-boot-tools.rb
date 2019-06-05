class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "http://ftp.denx.de/pub/u-boot/u-boot-2019.04.tar.bz2"
  sha256 "76b7772d156b3ddd7644c8a1736081e55b78828537ff714065d21dbade229bef"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ef92748f2dce7b805eb70b9e6381d15c4897206e62cc17041a0ec0ff76bf9078" => :mojave
    sha256 "c9af409154e2a3c626cab9711d1538b99eec39f977b11f2abf75ca34bae755e9" => :high_sierra
    sha256 "baef3b783798fee71d0623fc1387954cf1e190d501617ae56238bc75180fc2da" => :sierra
  end

  depends_on "openssl"

  def install
    system "make", "sandbox_defconfig"
    system "make", "tools"
    bin.install "tools/mkimage"
    bin.install "tools/dumpimage"
    man1.install "doc/mkimage.1"
  end

  test do
    system bin/"mkimage", "-V"
    system bin/"dumpimage", "-V"
  end
end
