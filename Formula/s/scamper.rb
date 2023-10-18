class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20230614d.tar.gz"
  sha256 "54423b64a0b68aafa903d9260c2bff5c16f3cca44997e0e830d17296f6f03a59"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5b52980f5fff5f36ca40140106793fdfac319b99a0bf77db20e3140a5b3ce379"
    sha256 cellar: :any,                 arm64_ventura:  "d47a95a586dc5a7598c3ee8c53b85e18f11e9ec882dc521d04ce47d9113d4645"
    sha256 cellar: :any,                 arm64_monterey: "064a2d684ec04f743eb5329615035d8779cc17cd8c369f22ca066622827bc1d1"
    sha256 cellar: :any,                 sonoma:         "b9468d1929999cf116d939aef2adfd1dacb611f619fa5e2df47128808e9f7ab5"
    sha256 cellar: :any,                 ventura:        "ba5f6c1d648c2160553f2d299ee2a95f9e77854fe9540601ffdff78723879305"
    sha256 cellar: :any,                 monterey:       "5db24bf9871049a12b13e504a6e8dc75d7d4fbc25ddbbeeec16fc4c2789fbb30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "140c0df4cfaa274e3d4666e1e9ccb91392abc7bda0fd59ebde2a5d466d31d823"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"
  depends_on "xz" # for LZMA

  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    expected = if OS.mac?
      "dl_bpf_open_dev"
    else
      "scamper_privsep_init"
    end
    assert_match expected, shell_output("#{bin}/scamper -i 127.0.0.1 2>&1", 255)
    assert_match version.to_s, shell_output("#{bin}/scamper -v")
  end
end
