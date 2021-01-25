class Sniffglue < Formula
  desc "Secure multithreaded packet sniffer"
  homepage "https://github.com/kpcyrd/sniffglue"
  url "https://github.com/kpcyrd/sniffglue/archive/v0.11.1.tar.gz"
  sha256 "f3d4a42ee12113ef82a8033bb0d64359af5425c821407a7469e99c7a5af3186d"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6c3bc15a04988b962743d108c67f28293829f96184e4c9d68e7a6e90bd0baa9c" => :big_sur
    sha256 "b461513034c9943c75eb70a7b23f0fdf4386760716a893e9b86cd81f3c637d4b" => :arm64_big_sur
    sha256 "3c1e6e2eca7f6441d0c892089bd46c8451dd5fa3b1f42350b05592bb7fef06b7" => :catalina
    sha256 "b781fc29156663e2b55f1fcb2a8647cf2eb2d452d43767c50ed9b57e88d92ff2" => :mojave
    sha256 "ad3744f7f3da5f36683cb16d0dbb3a5eaf0773cb59400eb972de68f12d999bb5" => :high_sierra
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
