class Yafc < Formula
  desc "Command-line FTP client"
  homepage "http://www.yafc-ftp.com/"
  url "http://www.yafc-ftp.com/downloads/yafc-1.3.7.tar.xz"
  sha256 "4b3ebf62423f21bdaa2449b66d15e8d0bb04215472cb63a31d473c3c3912c1e0"
  revision 1

  bottle do
    sha256 "7665d10fc6dd4cc6b7bced9145af75f6f9403b48b80b8579bbd0035cb13d6495" => :el_capitan
    sha256 "d485826eef7aa06d918a3d9c928f22b417a8fe4dc252002dd2487f9899179abe" => :yosemite
    sha256 "e382b1c32cea95f505242cda54555965772b00f37d8b251e86a0cb05be112b2e" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "readline"
  depends_on "libssh" => :recommended

  def install
    args = %W[
      --prefix=#{prefix}
      --with-readline=#{Formula["readline"].opt_prefix}
    ]
    args << "--without-ssh" if build.without? "libssh"

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
