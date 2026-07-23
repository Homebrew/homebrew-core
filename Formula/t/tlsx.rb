class Tlsx < Formula
  desc "Fast and configurable TLS grabber focused on TLS based data collection"
  homepage "https://github.com/projectdiscovery/tlsx"
  url "https://github.com/projectdiscovery/tlsx/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "f8f978b036b97b212ab4b954ba4a533adcb0425123d9dd8a4cde2d4948776628"
  license "MIT"
  head "https://github.com/projectdiscovery/tlsx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4291b474496c88a848df107ed0e5c0a20917d5858dcbead2d3e6a4fe8086bb7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9090bd262bd6ea5cc921a3f0b6894649c6ac4d96afacb7407f13f80ea83de322"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b74859eafbc1d675e52f0ab5d15ba20370741306449e4c52c28dcb4ce44ca201"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e3064fce8c98ee4e79d663757f408facbd3e2f254cc0354bbb95fbad9a445b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef98c1b39e5e5d2ada900b78e14b53f153e78fc051722b3a6268022577c0b694"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a134a2f3c2d08aab972728abea7f6ff18392d77d730e6bc57c2ed3c2fbc5c1d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/tlsx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tlsx -version 2>&1")
    system bin/"tlsx", "-u", "expired.badssl.com:443", "-expired"
  end
end
