class SourceHighlight < Formula
  desc "Source-code syntax highlighter"
  homepage "https://www.gnu.org/software/src-highlite/"
  url "https://ftp.gnu.org/gnu/src-highlite/source-highlight-3.1.8.tar.gz"
  mirror "https://ftpmirror.gnu.org/src-highlite/source-highlight-3.1.8.tar.gz"
  mirror "https://fossies.org/linux/www/source-highlight-3.1.8.tar.gz"
  sha256 "01336a7ea1d1ccc374201f7b81ffa94d0aecb33afc7d6903ebf9fbf33a55ada3"
  revision 10

  bottle do
    sha256 "9277cf220d941d23e2f8aa6fabc49e546d5d2141e10d86533ca0ab308f036552" => :mojave
    sha256 "e9cee3e1adb85f4342db18e9eb058cb1e890ab4787e2d80c7657379c59db0cf4" => :high_sierra
    sha256 "ac02e274218e45a543fca0478086bc3fed67d07deff990bf51065586c59602a9" => :sierra
  end

  depends_on "boost"

  needs :cxx11

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
