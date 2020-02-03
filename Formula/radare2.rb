class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/4.2.1.tar.gz"
  sha256 "70426b7a482f233058b2f161063d55f4a6ff26019e4b4f35a96c74057796009a"
  head "https://github.com/radare/radare2.git"

  bottle do
    sha256 "0e3b51ce92c61563752a1ae890036c44dbdd96819276bfea4e08a13068dc0118" => :catalina
    sha256 "d2bf3be2eaa107816dab43df40697a5e397fca05cb0fd79cf3ce61c6f1e512e7" => :mojave
    sha256 "d1f61654868be1c04c33f283f12843e3c4eee328474beb9167129015f3a1add3" => :high_sierra
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
