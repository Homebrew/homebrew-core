class SourceHighlight < Formula
  desc "Source-code syntax highlighter"
  homepage "https://www.gnu.org/software/src-highlite/"
  url "https://ftp.gnu.org/gnu/src-highlite/source-highlight-3.1.8.tar.gz"
  mirror "https://ftpmirror.gnu.org/src-highlite/source-highlight-3.1.8.tar.gz"
  mirror "https://fossies.org/linux/www/source-highlight-3.1.8.tar.gz"
  sha256 "01336a7ea1d1ccc374201f7b81ffa94d0aecb33afc7d6903ebf9fbf33a55ada3"
  revision 10

  bottle do
    sha256 "ed1d149a9f97855caee3f659c371a1478b68454efdadee059e34597218b982fe" => :mojave
    sha256 "88e245af7dfafc7cc0419fab616aa7d1ee16e3f47a36eab9e66bed809bbcd079" => :high_sierra
    sha256 "2889da5f2a4ce82b711fc2903e888e9410a8ae4d93fd26885b8d6b0b6b178505" => :sierra
    sha256 "85f7a45cd5ebde9700d332e72395a116287579e29ac000c80f8cb3fd6c8f843f" => :el_capitan
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
