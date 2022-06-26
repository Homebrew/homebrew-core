class Sniffglue < Formula
  desc "Secure multithreaded packet sniffer"
  homepage "https://github.com/kpcyrd/sniffglue"
  url "https://github.com/kpcyrd/sniffglue/archive/v0.15.0.tar.gz"
  sha256 "ac30c0748a4247d2a36b82d623e88863480c300d3f6bbbdc303077240a8292c5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72e503d05f93135533908160fd5177dfc127ace77105b1bb3f6cfbc07d14d8a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18cd8994cafdd4f65c8a3d8256a1bbfcd7b14509c80957c2cff317f08304e439"
    sha256 cellar: :any_skip_relocation, monterey:       "f06a73defd5704e2456c383969d10d5676fb90b1563b581701f7aa6bcd7cc32a"
    sha256 cellar: :any_skip_relocation, big_sur:        "7015cb6764ad2920116a4ff4d163450bc23475cb5554c1835e0c09abab350769"
    sha256 cellar: :any_skip_relocation, catalina:       "516c6d7ee05760c06cd9418a19107de3612eebf6196dc8f5efdf2f805e7a5fa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b67998a0546e7c4c19810d9f9b940ec15b4ff9206d18f2606d594cd41efa372a"
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
