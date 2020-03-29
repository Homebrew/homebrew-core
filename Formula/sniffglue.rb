class Sniffglue < Formula
  desc "Secure multithreaded packet sniffer"
  homepage "https://github.com/kpcyrd/sniffglue"
  url "https://github.com/kpcyrd/sniffglue/archive/v0.10.1.tar.gz"
  sha256 "27b9448a317957eface67fab1a264057b03b614b588031e4f47655a8e369ead7"

  bottle do
    cellar :any_skip_relocation
    sha256 "7a622b2d3018dda1d59b13bfcc04a81ddcc917855b229d5dea583a3d77676477" => :catalina
    sha256 "0efbd0283a8ad1aacedd6256972050054c92757ad9b1b80554b4eed55e13217a" => :mojave
    sha256 "0130451cd4305cbb61a06158b45caf20e7d3f4a869c0ae53d9d6b064421ac3e9" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "libpcap"

  resource "testdata" do
    url "https://github.com/kpcyrd/sniffglue/raw/163ca299bab711fb0082de216d07d7089c176de6/pcaps/SkypeIRC.pcap"
    sha256 "bac79a9c3413637f871193589d848697af895b7f2700d949022224d59aa6830f"
  end

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."

    etc.install "sniffglue.conf"
    man1.install "docs/sniffglue.1"
  end

  test do
    testpath.install resource("testdata")
    system "#{bin}/sniffglue", "-r", "SkypeIRC.pcap"
  end
end
