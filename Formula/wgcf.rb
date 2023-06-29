class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/v2.2.18.tar.gz"
  sha256 "9b2178407e423a4df176b256cd98b9f9f50577def2406fde556bdc187e41bbe6"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84cdf95426a75d2f9a2b5aaf6aca283023f8bb1c4f70620cee382cdb535f13f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84cdf95426a75d2f9a2b5aaf6aca283023f8bb1c4f70620cee382cdb535f13f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "84cdf95426a75d2f9a2b5aaf6aca283023f8bb1c4f70620cee382cdb535f13f2"
    sha256 cellar: :any_skip_relocation, ventura:        "7d25d38e04b81cfde125c0a8f3dc2d860a106e8d3a2ff22fce1dfd899aa2be53"
    sha256 cellar: :any_skip_relocation, monterey:       "7d25d38e04b81cfde125c0a8f3dc2d860a106e8d3a2ff22fce1dfd899aa2be53"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d25d38e04b81cfde125c0a8f3dc2d860a106e8d3a2ff22fce1dfd899aa2be53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fc13b7ae7dd5b483b60409096824c22d9c7319e6541db2cb50cf300bda5ec4a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"wgcf", "completion")
  end

  test do
    system "#{bin}/wgcf", "trace"
  end
end
