class Sniffglue < Formula
  desc "Secure multithreaded packet sniffer"
  homepage "https://github.com/kpcyrd/sniffglue"
  url "https://github.com/kpcyrd/sniffglue/archive/v0.13.0.tar.gz"
  sha256 "ad348a5219c337285545e36e0a8d5f7b08402095a4cf8ccd41aa84b91ca3b19a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6553139c58aa3dd91eed5d56e58c25bdc851084f3973421e21cb5ac5cb908df0"
    sha256 cellar: :any_skip_relocation, big_sur:       "807b2d72684f604b661b2539e5fbe326f8cbf2060f68cfedbd51ca5602146013"
    sha256 cellar: :any_skip_relocation, catalina:      "ff602a3b7afc7b6193399651cb923ae61610800b1e1a15ad6b39a833faf28e1d"
    sha256 cellar: :any_skip_relocation, mojave:        "071909cb1e3ba64edf4abf0fda2b6ccf4de286c9c5a2ae5c0d408d7977020b30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fc001eb98c95dd682bd816745607e6b0cfbcc84cc851a5c4bb0a94a8b998f78"
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
