class Topgit < Formula
  desc "Git patch queue manager"
  homepage "https://github.com/greenrd/topgit"
  url "https://github.com/greenrd/topgit/archive/topgit-0.9.tar.gz"
  sha256 "24b55f666e8d88ebf092a1df365492a659210a750c0793acb0c8560694203dfd"

  bottle do
    cellar :any_skip_relocation
    sha256 "5c1167b5d2f75b7b09d4b43ece472e2ae541d50ef2202afe08c14dbd8368ba06" => :sierra
    sha256 "a70a472becf5cdf957519831ff3365a7113b35c4d962f4159d23d89f7e5acc47" => :el_capitan
    sha256 "6ace8c6f3df714648de5cfc30ccb2066e589d9038fbf67796eeb4b76c7426989" => :yosemite
    sha256 "d682d50b1fda7c88b519153806d17886a46ef70840fc00d37a42e5b942ed50e7" => :mavericks
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end
end
