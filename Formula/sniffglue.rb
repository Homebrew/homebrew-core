class Sniffglue < Formula
  desc "Secure multithreaded packet sniffer"
  homepage "https://github.com/kpcyrd/sniffglue"
  url "https://github.com/kpcyrd/sniffglue/archive/v0.12.1.tar.gz"
  sha256 "a7c7f36b1fdf394baa0123730560f50613b7f7aeab63f60907932fa54b63b2c1"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6553139c58aa3dd91eed5d56e58c25bdc851084f3973421e21cb5ac5cb908df0"
    sha256 cellar: :any_skip_relocation, big_sur:       "807b2d72684f604b661b2539e5fbe326f8cbf2060f68cfedbd51ca5602146013"
    sha256 cellar: :any_skip_relocation, catalina:      "ff602a3b7afc7b6193399651cb923ae61610800b1e1a15ad6b39a833faf28e1d"
    sha256 cellar: :any_skip_relocation, mojave:        "071909cb1e3ba64edf4abf0fda2b6ccf4de286c9c5a2ae5c0d408d7977020b30"
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
