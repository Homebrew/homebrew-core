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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "47f78e73aac0167e695c58314dbe01c277c87247efa0414aead6f2fe56056d84"
    sha256 cellar: :any,                 arm64_sequoia: "6b25a0324c9f243227b8e28768930dba5880d3fed13a101e307251a69ba8f699"
    sha256 cellar: :any,                 arm64_sonoma:  "b2812101497a7135f6905b845a16fbf431a709d84abe3246f8065e4d8237d54d"
    sha256 cellar: :any,                 sonoma:        "6cfe785d536a562df48ecf86eac56c463afa6cbe7af417dde4b477328ca99188"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2deb85f1f1bb77f257d316e2862319ba040c81d729d9a837767f857b739dca97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cc8ff5978707ad576fa3cc0cf1d2a202f7053b055c333f5dc61c25c6afc9d81"
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
