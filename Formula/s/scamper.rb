class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20251113.tar.gz"
  sha256 "350f93566ffecc62dcab451397d5a2adab55aa316f1127bb154193b3a084294c"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ac0b13e5bce4f56257e28e11a60b124d80142267125171e4e938721591c653df"
    sha256 cellar: :any,                 arm64_sequoia: "8fdd4cc1f9913137274ffae288af5d2012b5a69ae9f5d3b46490c9d795b6139f"
    sha256 cellar: :any,                 arm64_sonoma:  "dcefac7e0ea17eaa68058685988d6954ddfa66119b74f94cd1e877d7a03ff645"
    sha256 cellar: :any,                 sonoma:        "c6a6a085f8bf66defaba5a5b46c2fbcc7f609b4788b3427492fdb56b7a3f3b62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c9c9f38453f9fea0226d976ab60dab8dee778d2b2e971e80d3c86454bf0e21f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e45a08b5b04d4facac8124297d23558da31d7bb4be703f098d9f1359f5203aaa"
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
