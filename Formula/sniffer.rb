class Sniffer < Formula
  desc "Modern alternative network traffic sniffer"
  homepage "https://github.com/chenjiandongx/sniffer"
  url "https://github.com/chenjiandongx/sniffer/archive/v0.6.0.tar.gz"
  sha256 "5f6479baf3fa003aa25247d280f4a8bf2130a346a20e6feb497633650900056f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a3c6378f7b77b4bfc62dc48df343f73fb7641c545b14a176e4fc69ba0618dd1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0803026712c591a78aa9f2833faf20cffc5c1e6f855422fc866fad008ff127a"
    sha256 cellar: :any_skip_relocation, monterey:       "4f9b40007a1197bd6e4414fe790f1f4bf1d680236fa334a633b9aa1c02b95918"
    sha256 cellar: :any_skip_relocation, big_sur:        "fcc192fa769f31050962e6c1521c4fd168f4afde940bdcc4ae812859b630f0e4"
    sha256 cellar: :any_skip_relocation, catalina:       "b87c1d0582ffd7ac1eb02bc3c783818649675b54e9f4316499484f848f261f0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e71af3474affa2c2308e7d3a4f38a4203ce68bc456e35768cb86629bc3e5d985"
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "lo", shell_output("#{bin}/sniffer -l")
  end
end
