class Topgit < Formula
  desc "Git patch queue manager"
  homepage "https://github.com/mackyle/topgit"
  url "https://github.com/mackyle/topgit/archive/topgit-0.19.12.tar.gz"
  sha256 "104eaf5b33bdc738a63603c4a661aab33fc59a5b8e3bb3bc58af7e4fc2d031da"

  bottle do
    cellar :any_skip_relocation
    sha256 "a33a1cd27a30392535a263631bf395b818abeb887a059ff1bb58bdf45ad4580b" => :mojave
    sha256 "bf554bc1d3a6afc87245deebbff89577c8e86e664681333956124da696b54629" => :high_sierra
    sha256 "5c1167b5d2f75b7b09d4b43ece472e2ae541d50ef2202afe08c14dbd8368ba06" => :sierra
    sha256 "a70a472becf5cdf957519831ff3365a7113b35c4d962f4159d23d89f7e5acc47" => :el_capitan
    sha256 "6ace8c6f3df714648de5cfc30ccb2066e589d9038fbf67796eeb4b76c7426989" => :yosemite
    sha256 "d682d50b1fda7c88b519153806d17886a46ef70840fc00d37a42e5b942ed50e7" => :mavericks
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end
end
