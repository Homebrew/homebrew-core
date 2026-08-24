class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20260713.tar.gz"
  sha256 "9fc67d6483e240dc38f098a3db13e99fcf678ad00667c6b32a0a2bedba7be697"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d12d6e91f7573dc1d964c5d314607576ec6ba350a75b5cbef0521ea55c39fbd4"
    sha256 cellar: :any, arm64_sequoia: "8897010f8a313d2f2f4ee49ef82526a27ed2de17542d1cc66554a88b29e5bf18"
    sha256 cellar: :any, arm64_sonoma:  "9cc1cb77c3caede21c043453b6b01193ce69622999afbfdfcdf398779c7fc805"
    sha256 cellar: :any, sonoma:        "08b7245155f1abbdd811f130a29457f3cdb613abf6554e9f47a5d8c10e159950"
    sha256 cellar: :any, arm64_linux:   "7db18337cd791295d5f6954c80e8d189969946a9deb56193377579934f9b7982"
    sha256 cellar: :any, x86_64_linux:  "b9bdbbdd659588c8f666ef99a67fb7559d19953998697750874d5c774fd5fd8c"
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
