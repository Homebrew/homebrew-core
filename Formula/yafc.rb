class Yafc < Formula
  desc "Command-line FTP client"
  homepage "https://github.com/sebastinas/yafc"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/y/yafc/yafc_1.3.7.orig.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/y/yafc/yafc_1.3.7.orig.tar.xz"
  sha256 "4b3ebf62423f21bdaa2449b66d15e8d0bb04215472cb63a31d473c3c3912c1e0"
  revision 2

  bottle do
    sha256 "0f008ef8835a41818a9134d5acf03e0832feb7d52a463f005279c10e745a4d15" => :mojave
    sha256 "a94fb7d29a96a322dad97aa8370c54036e792a593043b3ddf2e3536e59433af7" => :high_sierra
    sha256 "4a53da30ad16393321ca6e7b23afe335190b798045e9fa78a0ba8fe116e99718" => :sierra
    sha256 "ab8dc2d5aa90802d38bbc27344803a84bcce37df8854f7fe19035d3de77b12a2" => :el_capitan
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
