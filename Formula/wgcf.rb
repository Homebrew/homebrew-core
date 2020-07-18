class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/v1.0.6.tar.gz"
  sha256 "d3d3123d002c1b5dc5a321d4c122436981254951d1c46565575888a8bade44b3"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system "#{bin}/wgcf", "trace"
  end
end
