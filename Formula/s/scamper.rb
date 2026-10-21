class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20261019.tar.gz"
  sha256 "83fedacbea65c03d8ef754e0240d4dbfc2efb0cf3f62a5980d0d213c807c7698"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f7a89c6e154c58941e99afa0f4f59d10aaee5fbbb28e6b190099d21c591e947c"
    sha256 cellar: :any, arm64_tahoe:       "c3bd83158641a8b1e076cc75594943b74c48e9b91a830c364b26b85454eaa4bc"
    sha256 cellar: :any, arm64_sequoia:     "aabfbe3969fd02d1d8f888f8c3abda8d7553e312f79f1925e65cf59df5bc73a6"
    sha256 cellar: :any, arm64_linux:       "bd69a032f129ec03168834738774eee614235efb3ccf0ecde9eac2544471115d"
    sha256 cellar: :any, x86_64_linux:      "4ea013d2c32064c1a119de0e742cc1198f9613466120b90e99084f485b8576c0"
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
