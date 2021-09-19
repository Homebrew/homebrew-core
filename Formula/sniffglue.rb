class Sniffglue < Formula
  desc "Secure multithreaded packet sniffer"
  homepage "https://github.com/kpcyrd/sniffglue"
  url "https://github.com/kpcyrd/sniffglue/archive/v0.13.1.tar.gz"
  sha256 "5994522cb62b2555185f042dcb6dd57d8aaa0ebaf015958d18de79501e6736d2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6867fe5fd18b395984786d6b385fe40f7a4e8e2cb445b10160e0b5909c22fb2f"
    sha256 cellar: :any_skip_relocation, big_sur:       "f5c6e604ff357fc18299d58ee7fabaf5367c96d74ead8eec5e3fe48a3bc5a094"
    sha256 cellar: :any_skip_relocation, catalina:      "1bd82eb72d4bedc1f6ea571152a56702512aefba276ee91fefa6d615e4d40550"
    sha256 cellar: :any_skip_relocation, mojave:        "5f5c54123a64a027c297df1bb4cc644aef975dc7d037ca06d02b26995c194b48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f59cd66e73489c7847a0f3ee6f637eadd86eac9b5f336bc07058a76dfb62b102"
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
