class Sniffglue < Formula
  desc "Secure multithreaded packet sniffer"
  homepage "https://github.com/kpcyrd/sniffglue"
  url "https://github.com/kpcyrd/sniffglue/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "f30b31861b07160b4efe23eda996491aaf885037d6907227d2230cd0e7db3265"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b45c1ef8b0dd3da8de07cb373db7d60a8963466af4fe2c1998301aa121c1c3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d817e24ad305538cbcca6238e2107669e9491537211b9ecf57c85056d93a6755"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1a2a6038c16babfddc8abffe98bab38620bb7f94a1cb156992d4ab667a16313"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "56da20d0f884e5d65f47710f07b161811f899e914a02444f25013de4318280dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e384b4c3f1cec37f8bfc05895374176b0653d23da223e32fe8911c896509736"
    sha256 cellar: :any_skip_relocation, ventura:       "c02d4c036be412e02824d1fd6dececfab12e47b70e0030aca18a26ebac05d31d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2c11e8addb595af6b63ed633911aaeaddf6f373bb4ad43870fc0c1739858d34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "975e2e1aa4e743d501b15ab83d7af6360d5d0ec2335051d2719ad817c56c6ac6"
  end

  depends_on "rust" => :build
  depends_on "scdoc" => :build

  uses_from_macos "libpcap"

  on_linux do
    depends_on "libseccomp"
  end

  def install
    system "cargo", "install", *std_cargo_args
    system "make", "docs"

    etc.install "sniffglue.conf"
    man1.install "docs/sniffglue.1"

    generate_completions_from_executable(bin/"sniffglue", "--gen-completions")
  end

  test do
    resource "homebrew-testdata" do
      url "https://github.com/kpcyrd/sniffglue/raw/163ca299bab711fb0082de216d07d7089c176de6/pcaps/SkypeIRC.pcap"
      sha256 "bac79a9c3413637f871193589d848697af895b7f2700d949022224d59aa6830f"
    end

    testpath.install resource("homebrew-testdata")
    system bin/"sniffglue", "-r", "SkypeIRC.pcap"
  end
end
