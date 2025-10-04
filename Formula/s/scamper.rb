class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20251002.tar.gz"
  sha256 "8487c6c915dee110f028d55abb1e19ff773449a220eda6a94f33dfdd7c46464c"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c305838faa108211fbd9c59d0f1c503a7f4d091b95d840a16b24e7996061f30a"
    sha256 cellar: :any,                 arm64_sequoia: "22e85bc11cc08a8ef2237eaae189fcfa046a77454966bd4587c804f3f27c33f3"
    sha256 cellar: :any,                 arm64_sonoma:  "72c116bbc860d16a01f4a9416e76c52a2bd633e502d52450f17d81691e7b43df"
    sha256 cellar: :any,                 sonoma:        "cea4f9516ee58a32f0cb2edb32bc541b114f095cf68d11faaef216462369e308"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "742621e25d5678909f9b7c15c32fd3e7629f5db630d98f2246f889daaf6c4afd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2aa9cc9425dd4cb87333fcbdfe21b8cfc0463d8c52f3ee89a4102606b9d3c9ec"
  end

  depends_on "pkgconf" => :build
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
