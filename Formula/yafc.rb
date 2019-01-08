class Yafc < Formula
  desc "Command-line FTP client"
  homepage "https://github.com/sebastinas/yafc"
  url "https://deb.debian.org/debian/pool/main/y/yafc/yafc_1.3.7.orig.tar.xz"
  sha256 "4b3ebf62423f21bdaa2449b66d15e8d0bb04215472cb63a31d473c3c3912c1e0"
  revision 3

  bottle do
    cellar :any
    rebuild 1
    sha256 "54e0e78f88602efd8fe156f22231c62eb5065a199148da18a7e8ade6c89c0423" => :mojave
    sha256 "03e232625133ffa50672d0e0773d3ca4a96023c1f1e246b1433f9bffd6f45944" => :high_sierra
    sha256 "2f0587b27ac3e389b5c8a9c3c6dde127b4ee6eec4c79c610d943e72e88c199e1" => :sierra
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
