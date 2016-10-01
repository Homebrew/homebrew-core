class Tivodecode < Formula
  desc "Convert .tivo to .mpeg"
  homepage "http://tivodecode.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/tivodecode/tivodecode/0.2pre4/tivodecode-0.2pre4.tar.gz"
  sha256 "788839cc4ad66f5b20792e166514411705e8564f9f050584c54c3f1f452e9cdf"
  version "0.2pre4"

  bottle do
    cellar :any_skip_relocation
    sha256 "5682668b2e721933054656cebc49ccb46c382428b77409d94251c6f1dfd3092d" => :sierra
    sha256 "d50450e62c6fcf71643ceaf5f33dcf4e904e389c89597ccbe148de3053839ccd" => :el_capitan
    sha256 "cb74afdc87eca67025849836bee29e04f6c8e7755753a9daa52c84cfc9201cd8" => :yosemite
    sha256 "7622e7c60ecd22127b454e303d7c15b14c6cc79bcddf00c0de0de58e9350b5bd" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
