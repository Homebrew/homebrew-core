class Xml2 < Formula
  desc "Makes XML and HTML more amenable to classic UNIX text tools"
  homepage "https://web.archive.org/web/20160730094113/http://www.ofb.net/~egnor/xml2/"
  url "https://web.archive.org/web/20160427221603/http://download.ofb.net/gale/xml2-0.5.tar.gz"
  sha256 "e3203a5d3e5d4c634374e229acdbbe03fea41e8ccdef6a594a3ea50a50d29705"

  bottle do
    cellar :any_skip_relocation
    sha256 "5785498202dc54640b0d7ce48de39d675d5b2ecf2703bf60fa71a1f2b20f5d42" => :el_capitan
    sha256 "7099efc43bc968b2916dcae199bfd3b32e08b0dc25a463236dc6cc23d00a85de" => :yosemite
    sha256 "943d2f95f5ae95660f70bc0b3dca38eaf124d179ab3f2c9db204f81dfc44d3bb" => :mavericks
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "echo '<test/>' | \"#{bin}/xml2\""
  end
end
