class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20260420.tar.gz"
  sha256 "7d6f6b94e0b80439e45218318a92d30645a7bdbb23c711f68536c8f243fd3317"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dc1cdba89f1aeb9d49547af616d27c3689350b6789b94515b9236309d2f18235"
    sha256 cellar: :any,                 arm64_sequoia: "e4845c53fc6c793362e7c47f7b2d9138f50d9f8bbfaf95b02a8d50f31150b3a7"
    sha256 cellar: :any,                 arm64_sonoma:  "200615b7231dbcf5f33bdb6b1c483740264df9f352c0af594c80cfc8cf12fe92"
    sha256 cellar: :any,                 sonoma:        "cf00935fd7c6659264a576fdab126dc8fcb14fa194d60efb13b768c0404a7d2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae43b89b4ff5c5c928556739bbbc4848a3df5f10805cd5a83aff7f597d739dcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7fbe5d7b9b338ee344146658ca5caf7f0befb45de4b3b910d596ba87d688f2c"
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
