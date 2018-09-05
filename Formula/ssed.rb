class Ssed < Formula
  desc "Super sed stream editor"
  homepage "https://sed.sourceforge.io/grabbag/ssed/"
  url "https://sed.sourceforge.io/grabbag/ssed/sed-3.62.tar.gz"
  sha256 "af7ff67e052efabf3fd07d967161c39db0480adc7c01f5100a1996fec60b8ec4"

  bottle do
    sha256 "f9ed77103129ce1f3534eb7e7b735a72f5ea83442d46c11664b4a8a3883b1a0a" => :mojave
    sha256 "0cc13b472591ed0dab6bcb69f8c08e89cc217342c655355982b44e07a5f7318c" => :high_sierra
    sha256 "0834fb44e8acc946a9a7030b4313295777c3c9d8808f67c24daaaa2ce6c6a2ed" => :sierra
    sha256 "6c8c5a5547c7c97e59f1f7284083f46d5e61e7ab80ac08ebdfeec4a4b4e95fbb" => :el_capitan
    sha256 "7e313ca41f3a8e37bc91ab4a9d8c7acbf508cd7a89ac605df7cee3adcf108510" => :yosemite
    sha256 "448b2fdfee6f84c3d72fdf29d5ccd042027a9850ea16d75b5f4ee576d8cbadcc" => :mavericks
    sha256 "793435451341ea1e475bde0d46745ba233df28c5ed4bd86f7761a2fad3568fba" => :mountain_lion
  end

  conflicts_with "gnu-sed", :because => "both install share/info/sed.info"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}",
                          "--program-prefix=s"
    system "make", "install"
  end

  test do
    assert_equal "homebrew",
      pipe_output("#{bin}/ssed s/neyd/mebr/", "honeydew", 0).chomp
  end
end
