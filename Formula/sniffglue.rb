class Sniffglue < Formula
  desc "Secure multithreaded packet sniffer"
  homepage "https://github.com/kpcyrd/sniffglue"
  url "https://github.com/kpcyrd/sniffglue/archive/v0.13.1.tar.gz"
  sha256 "5994522cb62b2555185f042dcb6dd57d8aaa0ebaf015958d18de79501e6736d2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dc2afe546f93ea92d766db3bdcd40329b603ffccd24bc96ee7ce305d907c29fb"
    sha256 cellar: :any_skip_relocation, big_sur:       "5a0c5ca9616d27079fccf73dc4994a806fcfbff8abc53b1350609ac328c10be3"
    sha256 cellar: :any_skip_relocation, catalina:      "9475afdcd77b038fd6510b1cb4fb22bb603be494e1739bbfe61e8daff3f97ac0"
    sha256 cellar: :any_skip_relocation, mojave:        "1e78494d3a66ecf022491ec6a48af64e74f66cb51dcc339135635ee542d14e9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8161f45afec3e9cf59c43457d77b0b274b2d0f51f2e5bc96c65c6b3a88bee40f"
  end

  depends_on "rust" => :build

  uses_from_macos "libpcap"

  on_linux do
    depends_on "libseccomp"
  end

  resource "testdata" do
    url "https://github.com/kpcyrd/sniffglue/raw/163ca299bab711fb0082de216d07d7089c176de6/pcaps/SkypeIRC.pcap"
    sha256 "bac79a9c3413637f871193589d848697af895b7f2700d949022224d59aa6830f"
  end

  def install
    system "cargo", "install", *std_cargo_args

    etc.install "sniffglue.conf"
    man1.install "docs/sniffglue.1"
  end

  test do
    testpath.install resource("testdata")
    system bin/"sniffglue", "-r", "SkypeIRC.pcap"
  end
end
