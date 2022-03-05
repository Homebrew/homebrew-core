class Sniffglue < Formula
  desc "Secure multithreaded packet sniffer"
  homepage "https://github.com/kpcyrd/sniffglue"
  url "https://github.com/kpcyrd/sniffglue/archive/v0.15.0.tar.gz"
  sha256 "ac30c0748a4247d2a36b82d623e88863480c300d3f6bbbdc303077240a8292c5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71792cbed38923a976cc8efea8dd687cda67d6f784f4ef3c593c7a36cc733fa2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9dff099e2cbd6d5314cde13f133331d590f42d40743ba69981c269957e5e95e"
    sha256 cellar: :any_skip_relocation, monterey:       "739d4c1901fee3972adb91af6876e24f926a9cd6e5700a5034869c2c4e0d3f6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "572f8ca8ce788d8b12b6585ff01ea28c7c88f919b98d9aada7497afe20c9ce58"
    sha256 cellar: :any_skip_relocation, catalina:       "ff12c1cf459118bac72b2dc0e27a46acdaeaaa2177d9c87ffb0b4950d6a9c5b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a72e4880dc7c5a4017b7c5b05167a88b39ac24d08b286ce6755b92f851a0bcc"
  end

  depends_on "rust" => :build
  depends_on "scdoc" => :build

  uses_from_macos "libpcap"

  on_linux do
    depends_on "libseccomp"
  end

  resource "homebrew-testdata" do
    url "https://github.com/kpcyrd/sniffglue/raw/163ca299bab711fb0082de216d07d7089c176de6/pcaps/SkypeIRC.pcap"
    sha256 "bac79a9c3413637f871193589d848697af895b7f2700d949022224d59aa6830f"
  end

  def install
    system "cargo", "install", *std_cargo_args
    system "make", "docs"

    etc.install "sniffglue.conf"
    man1.install "docs/sniffglue.1"
  end

  test do
    testpath.install resource("homebrew-testdata")
    system bin/"sniffglue", "-r", "SkypeIRC.pcap"
  end
end
