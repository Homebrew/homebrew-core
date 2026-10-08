class Yafc < Formula
  desc "Command-line FTP client"
  homepage "https://github.com/sebastinas/yafc"
  url "https://deb.debian.org/debian/pool/main/y/yafc/yafc_1.3.7.orig.tar.xz"
  sha256 "4b3ebf62423f21bdaa2449b66d15e8d0bb04215472cb63a31d473c3c3912c1e0"
  license "GPL-2.0-or-later"
  revision 6

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "33c77d2ce1a28f818e57461d73377c65cfea89bd623ec18f4ef6e493e672a6f6"
    sha256 cellar: :any, arm64_tahoe:       "cb69480f1d270ee31f96e872c9a8d3dc1f3baab91b6af468a722c4aec71b0656"
    sha256 cellar: :any, arm64_sequoia:     "aaf40390ab22856e57a9963a40257a5a09d467ca5a81bb1d9e63bfb5280211b6"
    sha256 cellar: :any, arm64_linux:       "20646b0d7579f585477d859b268eebd447c1473dadfc835fc4b2083af42d8139"
    sha256 cellar: :any, x86_64_linux:      "ea87bb8a0d46d9bbea879c6c0d5f3642629ca83be9342e465221ef4698f6e6ef"
  end

  depends_on "pkgconf" => :build
  depends_on "libssh"
  depends_on "openssl@4"
  depends_on "readline"

  on_linux do
    depends_on "libbsd"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --with-readline=#{formula_opt_prefix("readline")}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    ftp_url = "ftp://ftp.mirrorservice.org/sites/ftp.gnu.org/gnu/gcc/gcc-10.2.0/"
    download_file = testpath/"gcc-10.2.0.tar.xz.sig"
    expected_checksum = Checksum.new("8e271266e0e3312bb1c384c48b01374e9c97305df781599760944e0a093fad38")
    output = pipe_output("#{bin}/yafc -W #{testpath} -a #{ftp_url}", "get #{download_file.basename}", 0)
    assert_match version.to_s, output
    download_file.verify_checksum expected_checksum
  end
end
