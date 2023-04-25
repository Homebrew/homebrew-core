class Snownews < Formula
  desc "Text mode RSS newsreader"
  homepage "https://sourceforge.net/projects/snownews/"
  url "https://downloads.sourceforge.net/project/snownews/snownews-1.11.tar.gz"
  sha256 "afd4db7c770f461a49e78bc36e97711f3066097b485319227e313ba253902467"
  license "GPL-3.0-only"

  bottle do
    sha256 arm64_ventura:  "7a2a22e0fd4e57c97784498a3cdb5918480cecf33beb5e2d0b660e515804e80c"
    sha256 arm64_monterey: "dbcc03abc9caace2f29b52c841686192e4298b60609c5f730f7b919db0c509bd"
    sha256 arm64_big_sur:  "555b6b9b49f2e34cfc457704d70b529a1d8344462a2320edd05f0cdbea5fd8ba"
    sha256 ventura:        "825119e4c619bb2369313fd47c9b73f4df2172a15647e401e7da4528ad8e9e51"
    sha256 monterey:       "944f14a89a33da5de2bc0d3808b09732b69b6ffbdc35e1f35c178b2f0fd4f49b"
    sha256 big_sur:        "d1bf3631b3f0c65e4b08c6b2042a7306cc6d1e8902403dda961add6c417c2837"
    sha256 x86_64_linux:   "bb1dccb514e53eb56a08d681c219c9632547f4798c80de3dbfbec23e8074f0fc"
  end

  depends_on "coreutils" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "ncurses"
  depends_on "openssl@1.1"

  uses_from_macos "curl"
  uses_from_macos "libxml2"

  def install
    system "./configure", "--prefix=#{prefix}"

    # Must supply -lz because configure relies on "xml2-config --libs"
    # for it, which doesn't work on OS X prior to 10.11
    system "make", "install", "EXTRA_LDFLAGS=#{ENV.ldflags} -L#{Formula["openssl@1.1"].opt_lib} -lz",
           "CC=#{ENV.cc}", "INSTALL=ginstall"
  end

  test do
    assert_match version.to_s, shell_output(bin/"snownews --help")
  end
end
