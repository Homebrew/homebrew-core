class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20260902.tar.gz"
  sha256 "a2c5bc636d6351a395f57e121b4d813f46c001e7b831b538fd467b9cbc7625de"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9736ca20f7ca0ca1f1b6f1aaa807d2c57d2e99359343ecf54eb5bd3b549130cc"
    sha256 cellar: :any, arm64_tahoe:       "e0601f8241076da65ec5e9efa8aaa28dcd524fc6faac3f6f17b4629ad617cc63"
    sha256 cellar: :any, arm64_sequoia:     "ea5acd2bd87287bf95a4906d09ea8c4912a1fb613fc0c2f73a12f8ad08c5756e"
    sha256 cellar: :any, arm64_sonoma:      "173ceeca357f7bdbc11d8cbf02a5ad02fd3792522977da899b4a4b467351842c"
    sha256 cellar: :any, arm64_linux:       "4c086c292231bb8f21a95be6d1591c17e66b4784323d9c497c47671223076e3b"
    sha256 cellar: :any, x86_64_linux:      "b7dd05c9b140144840bc61672e798245b31ec43c5628363a59d38fd9ac1b6c7a"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@4"
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
