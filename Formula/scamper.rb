class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20230614.tar.gz"
  sha256 "26f11ea025a4fdb0d07ef76c5c3b850f9a0a93c1e1aa88d352d600a907259276"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7d25ce6712db5339fa205bd7b095a760c17136ce1e063f87add43c27a7e72790"
    sha256 cellar: :any,                 arm64_monterey: "1fc30741fb5e4c6bda8252d0ce3180ce1402bdf79894b63d8b7f9de0b7e881e5"
    sha256 cellar: :any,                 arm64_big_sur:  "8535af57bf89a1c4e28c6c79c1aac83fa9a52cd81282a7bddd878e57f882e5c7"
    sha256 cellar: :any,                 ventura:        "068065067b28a18e1084fcca64560317ee1658dc05830b53dff2b86f50ad3e9e"
    sha256 cellar: :any,                 monterey:       "77286a15076ba5831e185ad99e55c5bbc25bcdab5f0a0ab4d177cabefc68e14c"
    sha256 cellar: :any,                 big_sur:        "6db574a1956ec6ee6ddfbe6150a636502afb8966dede5f3da0627de05bc0c43a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3af3d5050c884e8a7c7ba3ae60dc7344be15619fc4ef0f5ce94931032a222af"
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
