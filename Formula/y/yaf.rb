class Yaf < Formula
  desc "Yet another flowmeter: processes packet data from pcap(3)"
  homepage "https://tools.netsa.cert.org/yaf/"
  url "https://tools.netsa.cert.org/releases/yaf-2.18.2.tar.gz"
  sha256 "b2324e6c5468e4748e59d9f33312decc8e72cc9ee51e927cd7e77b3d3584d909"
  license "GPL-2.0-only"

  # NOTE: This should be updated to check the main `/yaf/download.html`
  # page when it links to a stable version again in the future.
  livecheck do
    url "https://tools.netsa.cert.org/yaf2/download.html"
    regex(/".*?yaf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "756afdea15655c6538c81f170dd9db318293eefa96ab01663530151fb5292536"
    sha256 cellar: :any,                 arm64_sequoia: "d8c644685f9c5e24e5d66b5678044314cf1c9ebce0910f1cc6c7b39ba8360d88"
    sha256 cellar: :any,                 arm64_sonoma:  "d7c935cb32c72ea3e7d5e59cc998cc4c2fca92010447110dc6a7bede3e290f6d"
    sha256 cellar: :any,                 sonoma:        "4b4a407d6be6b4e06a9a2e6ed3d282761d8ee2e41ec0521deecdae25537fc705"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4020382f47f691a4c43be0767d52e1be8bff6cec7cef443b5d1bab204d48092f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b884b07695ba889516f481a2025328b2f11b94529f4c608288e1da05bc3b1309"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "libfixbuf"
  depends_on "libtool"

  uses_from_macos "libpcap"

  on_macos do
    depends_on "gettext"
    depends_on "openssl@3"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    input = test_fixtures("test.pcap")
    output = pipe_output("#{bin}/yafscii", shell_output("#{bin}/yaf --in #{input}"), 0)
    expected = "2014-10-02 10:29:06.168497 - 10:29:06.169875 (0.001378 sec) tcp " \
               "192.168.1.115:51613 => 192.168.1.118:80 71487608:98fc8ced " \
               "S/APF:AS/APF (7/453 <-> 5/578) rtt 451 us"
    assert_equal expected, output.strip
  end
end
