class Yafc < Formula
  desc "Command-line FTP client"
  homepage "https://github.com/sebastinas/yafc"
  url "https://deb.debian.org/debian/pool/main/y/yafc/yafc_1.3.7.orig.tar.xz"
  sha256 "4b3ebf62423f21bdaa2449b66d15e8d0bb04215472cb63a31d473c3c3912c1e0"
  revision 3

  bottle do
    cellar :any
    sha256 "3d78256e0dba7627da06cdcc45b6d4a070d7d1b533457d3af439840150e68aa2" => :mojave
    sha256 "882e689f69c445379a242d5591b286c7ec53fc0eca5402ed758038427404d8f7" => :high_sierra
    sha256 "ebb0f01446ebacf7f72930afd99393fa24efe2eb604405d377b8feca63472c6f" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libssh"
  depends_on "readline"

  def install
    args = %W[
      --prefix=#{prefix}
      --with-readline=#{Formula["readline"].opt_prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    download_file = testpath/"512KB.zip"
    expected_checksum = Checksum.new("sha256", "07854d2fef297a06ba81685e660c332de36d5d18d546927d30daad6d7fda1541")
    output = pipe_output("#{bin}/yafc -W #{testpath} -a ftp://speedtest.tele2.net/", "get #{download_file.basename}", 0)
    assert_match version.to_s, output
    download_file.verify_checksum expected_checksum
  end
end
