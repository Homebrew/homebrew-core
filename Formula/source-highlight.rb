class SourceHighlight < Formula
  desc "Source-code syntax highlighter"
  homepage "https://www.gnu.org/software/src-highlite/"
  url "https://ftp.gnu.org/gnu/src-highlite/source-highlight-3.1.8.tar.gz"
  mirror "https://ftpmirror.gnu.org/src-highlite/source-highlight-3.1.8.tar.gz"
  mirror "https://fossies.org/linux/www/source-highlight-3.1.8.tar.gz"
  sha256 "01336a7ea1d1ccc374201f7b81ffa94d0aecb33afc7d6903ebf9fbf33a55ada3"
  revision 13

  bottle do
    sha256 "688ef215f8f36547792ac63e3ece3e84e0a9e9606a19f24d19183c880c5e56bb" => :mojave
    sha256 "df9fd53dc9cfaba19cea8d95c807ee14424dfc5f557a19366d905104c95ed6d5" => :high_sierra
    sha256 "7c36028c9728b35dbb20ed0d19e064e5f29c4929d01c95c87d8945e664d13e23" => :sierra
  end

  depends_on "boost"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{Formula["boost"].opt_prefix}"
    system "make", "install"

    bash_completion.install "completion/source-highlight"
  end

  test do
    assert_match /GNU Source-highlight #{version}/, shell_output("#{bin}/source-highlight -V")
  end
end
