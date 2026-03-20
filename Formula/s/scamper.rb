class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20260204.tar.gz"
  sha256 "a3652614b1a85a13523487679ba36242270184d2d5c9a2b415e0e0a2e4f6c8e1"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "8aa94286816fcbe152e2032e5897f420f68385bb44a5863a7bce8c9c57a5d5e5"
    sha256 cellar: :any,                 arm64_sequoia: "ae1bb5f421f78238e2bf2dde5ca2015d8b0bd2d330c8159d58b45b747602acc5"
    sha256 cellar: :any,                 arm64_sonoma:  "dfac4a1de62631ac400dcd96da1d72e7ed82302c171a9b6adfb395c5871ba3a8"
    sha256 cellar: :any,                 sonoma:        "df86bbe854d1945a8dc4f6eadf416463f8cf735f28963c4df0415a7711ece941"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f125eaa55edf070d1c8513f29e7c806ebcc23f4bb6e2477bbf60801102aafc55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7c20a4d8bada5168b79826d13a9c4eb84e317807b5a7742c6e12088fb7e8635"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"
  depends_on "xz" # for LZMA

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
