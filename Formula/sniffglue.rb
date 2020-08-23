class Sniffglue < Formula
  desc "Secure multithreaded packet sniffer"
  homepage "https://github.com/kpcyrd/sniffglue"
  url "https://github.com/kpcyrd/sniffglue/archive/v0.11.1.tar.gz"
  sha256 "f3d4a42ee12113ef82a8033bb0d64359af5425c821407a7469e99c7a5af3186d"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "9eb84327d14362e98f5c28bc8de59d85fb975348206d7d17d2e9ca601743a4b2" => :catalina
    sha256 "7cf69e349503bc79fd6143df0ade8e5e2afb7bbe08b25374da4507216fd90a3f" => :mojave
    sha256 "765e71bbc155e4aca03eba31e3827564413114e7812d33769e8b91c3bfc9f761" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "libpcap"

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
