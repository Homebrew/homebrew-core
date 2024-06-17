class Sniffglue < Formula
  desc "Secure multithreaded packet sniffer"
  homepage "https://github.com/kpcyrd/sniffglue"
  url "https://github.com/kpcyrd/sniffglue/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "d707507e55a8697574322750eff066d9d5caf18e87a9ee1ddd1722549f2b9267"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "de749d31508f27f01895d33bf06d801fb7ae8b784aa5e8aafbe65bf97551726b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "967a3e7e35ec0f85e1251bdd23593a3fe1a705fd9db55b6d3d252acc6dee08f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0124fdc57c2758c8e46b01486342838f0ec9236051162eff1e69de2652e925ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "b87a026eaa0ef6b112f697606343d44dfa0fec788c51bb5b783415f33ecbc769"
    sha256 cellar: :any_skip_relocation, ventura:        "ab917fc873d321650062f6a41cc8702c873ef44a2d14ad987a7cf2bf878c06e1"
    sha256 cellar: :any_skip_relocation, monterey:       "499278c450b14d7c91962e46696b7ad418521e17e761dc8885d63d3e19bcbe7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c205f8ff87d54858e9b0db415869a2ad39c84eef300d85fc19031cb493c429cb"
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
