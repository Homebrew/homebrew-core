class Tlsx < Formula
  desc "Fast and configurable TLS grabber focused on TLS based data collection"
  homepage "https://github.com/projectdiscovery/tlsx"
  url "https://github.com/projectdiscovery/tlsx/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "8a75d2d77c8e7fe20c744a86dd7d1b7905a73028f46692363957928658f39df3"
  license "MIT"
  head "https://github.com/projectdiscovery/tlsx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "777e14316f84d520e150b34c024c8d69437941253773cddadd57b98eb73cb45d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "777e14316f84d520e150b34c024c8d69437941253773cddadd57b98eb73cb45d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "777e14316f84d520e150b34c024c8d69437941253773cddadd57b98eb73cb45d"
    sha256 cellar: :any_skip_relocation, ventura:        "0b0f260ea0f2a142b18771037bc24f334799cdb596d997df107dc6455c749b28"
    sha256 cellar: :any_skip_relocation, monterey:       "6d3f1909866624449133138e3df766b3eb675a04da7ae1e71418130be43ef960"
    sha256 cellar: :any_skip_relocation, big_sur:        "a41234e9068602f187de9b5b08c3eeb3f5c3e8fb7b281001e09cea6247c9ee77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "715951cc8c75c5262856d0699bebeda8bcb8f62c987305e9cc29612d294d5053"
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
