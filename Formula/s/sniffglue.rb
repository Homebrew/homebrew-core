class Sniffglue < Formula
  desc "Secure multithreaded packet sniffer"
  homepage "https://github.com/kpcyrd/sniffglue"
  url "https://github.com/kpcyrd/sniffglue/archive/v0.15.0.tar.gz"
  sha256 "ac30c0748a4247d2a36b82d623e88863480c300d3f6bbbdc303077240a8292c5"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89e5d71d3cddef8835e55dfc9e5605d6cf55e3a2becd96ad4773e87af939d612"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6f259b1ea3c567419536c66de207f2e2c382041f742c57f2cfc40d73d3076bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "691236273406849e741183f18c1fc13de92fb4c99b24abfe3cd4a8b6cf79d925"
    sha256 cellar: :any_skip_relocation, ventura:        "c6d71697ecb9b1edde9b08f2a5566d73067859549f3900f012b89ce671e84a80"
    sha256 cellar: :any_skip_relocation, monterey:       "1c130fb065a2bfcac7396277ae4c8d22995202f800defb110915cff1db13a8ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "69d676dd88ea3974acbfa8eb09c0bb34abfca2769d32a6d5ada2dfae45bdbcbf"
    sha256 cellar: :any_skip_relocation, catalina:       "f95efe25bbdb5cdd8c9be45246342430ea56a944f93b2cbb93f382fdf345309a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "676a1bb4a02fb1ef5ec6f08a229e2b276bd446b11b99388d592963e958aa8398"
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
