class Tlsx < Formula
  desc "Fast and configurable TLS grabber focused on TLS based data collection"
  homepage "https://github.com/projectdiscovery/tlsx"
  url "https://github.com/projectdiscovery/tlsx/archive/refs/tags/v1.1.9.tar.gz"
  sha256 "96280c609d8e82258ec2da99487702d1696d6430bdd179cbc64ff035be8f92c9"
  license "MIT"
  head "https://github.com/projectdiscovery/tlsx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a75b7caa8eb3620f06e521b5089a6f855fbc678a5b33f94d3f4aa7257cc7769"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f86c2d8958e80ee7fc67d722fb365daf6464db063a9d2628e345ac57c4985b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b9e4d8105f1b75e0dd35719a9abf3252c0d22c1da0fc85376172467eceb1973"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ebb76c7c8f89a1865a76458f82b912d7d68b3a203822f88a43e40f4db151150"
    sha256 cellar: :any_skip_relocation, ventura:       "0c2a977abfdd73a2f4f4e215ec9988620b22ff539b355c42d67922079ef31a31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64a75bb051709028ee1165ac69fa0ec92189a8e4a0899cc283fd7fc3ecd630d4"
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
