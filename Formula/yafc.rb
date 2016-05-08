class Yafc < Formula
  desc "Command-line FTP client"
  homepage "http://www.yafc-ftp.com/"
  url "http://www.yafc-ftp.com/downloads/yafc-1.3.7.tar.xz"
  sha256 "4b3ebf62423f21bdaa2449b66d15e8d0bb04215472cb63a31d473c3c3912c1e0"

  bottle do
    revision 2
    sha256 "85e490aee51701da0f7602b9d88700f18b6b2077dcae1f17c5c479132dd78d2e" => :el_capitan
    sha256 "3f5fc5f56cce04404d49d82173d4aea09b3fdfd3dec7b3699ea106b947a6df2a" => :yosemite
    sha256 "5f178c01235c5dd28bd359eb295a4a0aa848649c63a0a0386f43516d32b66bd2" => :mavericks
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
