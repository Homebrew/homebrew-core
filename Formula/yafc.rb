class Yafc < Formula
  desc "Command-line FTP client"
  homepage "http://www.yafc-ftp.com/"
  url "http://www.yafc-ftp.com/downloads/yafc-1.3.7.tar.xz"
  sha256 "4b3ebf62423f21bdaa2449b66d15e8d0bb04215472cb63a31d473c3c3912c1e0"
  revision 1

  bottle do
    sha256 "05ea440c672b5283feaf2597a8c0525d3ff4228cd2347aabd3a69d282d245dd2" => :sierra
    sha256 "9cbbd25ce9019d92e6ed3c8ce5af9533b0d79d79f96b01fc8741016a3bd4eb39" => :el_capitan
    sha256 "3ac839135bac59b4d1d98cb662adc558109167fd21e69976dd39e1e3602de25b" => :yosemite
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
