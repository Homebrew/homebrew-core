class Tlsx < Formula
  desc "Fast and configurable TLS grabber focused on TLS based data collection"
  homepage "https://github.com/projectdiscovery/tlsx"
  url "https://github.com/projectdiscovery/tlsx/archive/v0.0.5.tar.gz"
  sha256 "f505d6154a204a834c1ff54065aa43fb64a8f127db433a30eead16c74483ebb7"
  license "MIT"
  head "https://github.com/projectdiscovery/tlsx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2546597a2dbc490f555f5db8d372c3f2e443d2458afe19b776d4ebf55fd93a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "efe4c6c23fc4feb5204ce943fd74801ef0311f8f39797db2eefe1b1813e99c5d"
    sha256 cellar: :any_skip_relocation, monterey:       "0f3f8c81a9a016a79b770a0e673561911429198d5e36fe8f741fe587e4dc7485"
    sha256 cellar: :any_skip_relocation, big_sur:        "237012a6cf3fb26ad8e809050bae494a16bd029fe79611144dda22c46787af78"
    sha256 cellar: :any_skip_relocation, catalina:       "579aa97a7ca57b3be3551d581210a783cf748458401197df68600b2949ef704d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23f0cf20239ae66d4075d8c59476ed21dc426c689a637297052f414e6f6d33fd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/tlsx/main.go"
  end

  test do
    system "tlsx", "-u", "expired.badssl.com:443", "-expired"
  end
end
