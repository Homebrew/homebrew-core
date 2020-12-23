class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/5.0.0.tar.gz"
  sha256 "517dd80ebd0569f31498887338eacb92e8cf054bc4625eef8ffe9ea174c1adae"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git"

  bottle do
    rebuild 1
    sha256 "c7afb84ee74ee69d89595c0d89ee97c3778442c96286ffcc337eb6cd01970298" => :big_sur
    sha256 "7471bcb207882abe2a594dc14db2bb54858b7cbf8d565bb37c4ce6c8cec50913" => :catalina
    sha256 "5c47780424cf1b4121bf36f54fa65adc4be29b672fa8ad8d634adff6e1b4bc1d" => :mojave
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
