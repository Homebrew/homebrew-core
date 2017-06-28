class SourceHighlight < Formula
  desc "Source-code syntax highlighter"
  homepage "https://www.gnu.org/software/src-highlite/"
  url "https://ftp.gnu.org/gnu/src-highlite/source-highlight-3.1.8.tar.gz"
  mirror "https://ftpmirror.gnu.org/src-highlite/source-highlight-3.1.8.tar.gz"
  mirror "https://fossies.org/linux/www/source-highlight-3.1.8.tar.gz"
  sha256 "01336a7ea1d1ccc374201f7b81ffa94d0aecb33afc7d6903ebf9fbf33a55ada3"
  revision 5

  bottle do
    sha256 "a366f9add09de541bed40859ff81417b6a8639366187492258c8b1af5725ba71" => :sierra
    sha256 "9146b9804b82a54f197105d1b37eb8af2a9a29b96ed1c7343d6dbec905886b63" => :el_capitan
    sha256 "a5e76856bc46279d1fb59e89db29b496baf9042200a1216b2127ee31511ee936" => :yosemite
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
