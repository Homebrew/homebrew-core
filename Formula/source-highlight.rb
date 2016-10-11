class SourceHighlight < Formula
  desc "Source-code syntax highlighter"
  homepage "https://www.gnu.org/software/src-highlite/"
  url "https://ftpmirror.gnu.org/src-highlite/source-highlight-3.1.8.tar.gz"
  mirror "https://ftp.gnu.org/gnu/src-highlite/source-highlight-3.1.8.tar.gz"
  mirror "http://mirror.anl.gov/pub/gnu/src-highlite/source-highlight-3.1.8.tar.gz"
  sha256 "01336a7ea1d1ccc374201f7b81ffa94d0aecb33afc7d6903ebf9fbf33a55ada3"
  revision 3

  bottle do
    sha256 "32431a6ab8ec1190dfcc53127db97106f70ab0d07f59a6f795a69a9bb3f67057" => :sierra
    sha256 "d9d85ea49968be79d04337ed71d5888b0036b398574b710a568c7ffd0b9bbc66" => :el_capitan
    sha256 "244103552e83e49158e6e21a86f96d3270f258c29dca531e7fcb8dec1b9a9627" => :yosemite
  end

  depends_on "boost"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{HOMEBREW_PREFIX}"
    system "make", "install"

    bash_completion.install "completion/source-highlight"
  end

  test do
    assert_match /GNU Source-highlight #{version}/, shell_output("#{bin}/source-highlight -V")
  end
end
