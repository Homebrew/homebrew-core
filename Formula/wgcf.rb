class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/v2.2.14.tar.gz"
  sha256 "64b6e62cc9b7ca1b91757ee067e7c6adf923faff64e3daeebbf07ad817ce73aa"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "218e65c535faf4c931b52f49a3993f2e161ca67459c0af2028258a45e1e215b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "934e17a34b48e2f56aa4278f30de006cc5ca781d31bc09851ad2b3337fa65963"
    sha256 cellar: :any_skip_relocation, monterey:       "bb54096917d918e1f6a59cb7b434a142c5251caebbab4da14ebd0a5eb2dca0bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7bb88537cce776ca52ce2e8e5cf3fbb803026f67e21a2a2871670b36a0978b1"
    sha256 cellar: :any_skip_relocation, catalina:       "7b4e81922a4b6ca2d83d0ca32e98dd54c8815f357f2dcb4b9d3964e76fe42645"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a4e5e01061db8ea8d0f9ac3adf8d851bada70a3a021eb43938888bd61ef6e8d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/wgcf", "trace"
  end
end
