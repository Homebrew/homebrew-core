class Tlsx < Formula
  desc "Fast and configurable TLS grabber focused on TLS based data collection"
  homepage "https://github.com/projectdiscovery/tlsx"
  url "https://github.com/projectdiscovery/tlsx/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "d79c827791275a9ad4b5967b06828deecab55bedb2b7af641a6c01a28e37f113"
  license "MIT"
  head "https://github.com/projectdiscovery/tlsx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25ccf9a4adab06e88260f863187fb359ae9af9e759a418571e0705ecc0ab0007"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b523148d9ff50e73445a9df48bf3687f12db49373c4897681b72fc454dfe40da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40c8b59e628608c15ea5a079e9fd4a1f728244df2025c7c7d06cc5a28c55f0dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4910b7d50091cdcb006c704f748248db8d01739cdeb10332451e21d78f1162d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "743d4e7e663604afe1c9f4311c5cbe047644c2e4342373969c6a2c44ac8d5cac"
    sha256 cellar: :any_skip_relocation, ventura:       "02cee159f2b303a124a4ed749730b301fa6d5a7dc50e551c1ee248e59b14fb73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17c25ab219ce2f06967bff6fe499ed44fa9dc6ab7c20225ef50369eaca6ef3a7"
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
