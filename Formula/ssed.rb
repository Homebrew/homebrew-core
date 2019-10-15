class Ssed < Formula
  desc "Super sed stream editor"
  homepage "https://sed.sourceforge.io/grabbag/ssed/"
  url "https://sed.sourceforge.io/grabbag/ssed/sed-3.62.tar.gz"
  sha256 "af7ff67e052efabf3fd07d967161c39db0480adc7c01f5100a1996fec60b8ec4"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "21b9139163cd1f1ddf11ad063e4e9c2409d7c73cba2473912d9117a1631205b8" => :catalina
    sha256 "3684fa95549fe291253881be5f173e9cff43940be146842f3576a48c7052e234" => :mojave
    sha256 "cc8945d2f1d9849181c61650958ba6f90a1ff4f4d7dfacf265b5d13921d0a91b" => :high_sierra
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
