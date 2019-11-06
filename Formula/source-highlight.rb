class SourceHighlight < Formula
  desc "Source-code syntax highlighter"
  homepage "https://www.gnu.org/software/src-highlite/"
  url "https://ftp.gnu.org/gnu/src-highlite/source-highlight-3.1.9.tar.gz"
  mirror "https://ftpmirror.gnu.org/src-highlite/source-highlight-3.1.9.tar.gz"
  sha256 "3a7fd28378cb5416f8de2c9e77196ec915145d44e30ff4e0ee8beb3fe6211c91"

  bottle do
    sha256 "6975c8ff628b6780b652097e96771de14426a6caa6e10b020bca8a295b0e624e" => :catalina
    sha256 "ef230217d8347636a41eb0a6ae506b21120ea281e587db4a77fcc0d677f8770a" => :mojave
    sha256 "f03b129e2e25aeab1b6e8fae7e05860cfb1a26bed7b86060382fee76aa88b12c" => :high_sierra
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
