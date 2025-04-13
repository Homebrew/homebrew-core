class Snownews < Formula
  desc "Text mode RSS newsreader"
  homepage "https://sourceforge.net/projects/snownews/"
  url "https://downloads.sourceforge.net/project/snownews/snownews-1.11.tar.gz"
  sha256 "afd4db7c770f461a49e78bc36e97711f3066097b485319227e313ba253902467"
  license "GPL-3.0-only"
  revision 1

  bottle do
    sha256 arm64_sequoia:  "0a953106b529951a0e5900c9819c2df6ef3b26822fa3ce924c333546f9264734"
    sha256 arm64_sonoma:   "aeeabd29b3c85814440dad193c88e96de8bbdc802e38f5b6fc998425d90dfc1d"
    sha256 arm64_ventura:  "ab994b373b5e6a36f4c05d128dd2b4aff607a093d4bedbda6e0c3a38e63de933"
    sha256 arm64_monterey: "5e86f2dcc050b2bcb052eb43a4d8e146ff2f226d5c62476e356720c3b38484ff"
    sha256 arm64_big_sur:  "62bf089ff62731aff7786cbc262f644d8c1e6f9027e30c3d23e515281c2343c7"
    sha256 sonoma:         "0c0a56409995bb878cb4b50aa2b99f5415adba2e96899bc910cbfa0a64a68efc"
    sha256 ventura:        "35c17b0d8809918731e6f942a4ffabacf6f765bc0c28f0349cfde4fdccc76e01"
    sha256 monterey:       "84d7beb8653c713161180127550d58c277ccdc9253941fd1bce3bbb2d86419a2"
    sha256 big_sur:        "36c1b6a9f496f530d31eb71cb50c74f57075f73e4a5a101e2c81be5bb9698940"
    sha256 arm64_linux:    "dcd9bbda7584163d13f96f37ae60f89995110a90828c3864e02969da1f82b139"
    sha256 x86_64_linux:   "dfd5d4c92583abd0e7b299f6ac41eb728e814f6aba8a7ebf9fca9e8392d80f9e"
  end

  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "ncurses"
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install", "CC=#{ENV.cc}"
  end

  test do
    assert_match version.to_s, shell_output(bin/"snownews --help")
  end
end
