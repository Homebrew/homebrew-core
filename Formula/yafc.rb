class Yafc < Formula
  desc "Command-line FTP client"
  homepage "https://github.com/sebastinas/yafc"
  url "https://deb.debian.org/debian/pool/main/y/yafc/yafc_1.3.7.orig.tar.xz"
  sha256 "4b3ebf62423f21bdaa2449b66d15e8d0bb04215472cb63a31d473c3c3912c1e0"
  revision 4

  bottle do
    sha256 cellar: :any, arm64_monterey: "11de34b459b80ebed5cd72df3a8204183ddd8ea45ed90eacaa7b78db0e173226"
    sha256 cellar: :any, arm64_big_sur:  "f4f4f59642cd4d9600120a84ec67bf17d72bc1a9d716553f81b644185d4d9a96"
    sha256 cellar: :any, monterey:       "3020cbad354bc45ef1b73eaf527dea9db9b276870b42063d11ddab2122490382"
    sha256 cellar: :any, big_sur:        "2a62777a7fbe8dafe0eeb3f8a8eeaf41b100245ef1fca4ad897068ad1282c558"
    sha256 cellar: :any, catalina:       "07a19edcc11987e0de79538413a41b683c86de41d216eb2c120f747a3564bfd4"
    sha256 cellar: :any, mojave:         "f01687e9e00211d729d0d6bb191d6286b41693c52ecf2e6c5a26874c27589daa"
    sha256 cellar: :any, high_sierra:    "d2344380f7cee870732888ac9675303edd374400d5c1bbde02f822d09e93d186"
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
    download_file = testpath/"gcc-10.2.0.tar.xz.sig"
    expected_checksum = Checksum.new("8e271266e0e3312bb1c384c48b01374e9c97305df781599760944e0a093fad38")
    output = pipe_output("#{bin}/yafc -W #{testpath} -a ftp://ftp.gnu.org/gnu/gcc/gcc-10.2.0/",
                         "get #{download_file.basename}", 0)
    assert_match version.to_s, output
    download_file.verify_checksum expected_checksum
  end
end
