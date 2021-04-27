class Sniffglue < Formula
  desc "Secure multithreaded packet sniffer"
  homepage "https://github.com/kpcyrd/sniffglue"
  url "https://github.com/kpcyrd/sniffglue/archive/v0.12.1.tar.gz"
  sha256 "a7c7f36b1fdf394baa0123730560f50613b7f7aeab63f60907932fa54b63b2c1"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7711fba881a079e3de12648a63c98d4e97539973408ec444b091b6b301eff433"
    sha256 cellar: :any_skip_relocation, big_sur:       "6d6894afc00176326c7b4932573c427d545b99faebecd38e95eefe41b3135872"
    sha256 cellar: :any_skip_relocation, catalina:      "5fc37f26b3b0f6732901f1d6a2ad4143c133c787b49266517f509ef7c59c48c1"
    sha256 cellar: :any_skip_relocation, mojave:        "d6a6dc71f619a033e206bd37a96ee59256b68996630ce32574cf6f5c99977c35"
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
    system "#{bin}/sniffglue", "-r", "SkypeIRC.pcap"
  end
end
