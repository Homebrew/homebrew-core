class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/v2.2.9.tar.gz"
  sha256 "2620d865913bfe272f97ecf0bdee9e84c72223b284ebba9a88f3ef0c4ce0f0e3"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2057888bbbc44e55e634fbdaf0336e4e9b255342bb9f7e9c0edea8c9d1849464"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98a1f6a866624c58ad996e0442bd41c09ad34c59b9bcde48536a3075e6ce6104"
    sha256 cellar: :any_skip_relocation, monterey:       "da003ad314f90abb890fc508ffc19f37508ebf895ab52dace20cd30e71d58892"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b68e4fe26b6409b61fc350f5b35cccf4c3961d3fea459026bc78bb6bc9002ca"
    sha256 cellar: :any_skip_relocation, catalina:       "9162b9f58eb5bc9a652e4d41294193330551053e6ddfcf4e4486f94438604a33"
    sha256 cellar: :any_skip_relocation, mojave:         "0e3fb69476c5834721edb717f058295f42e652eddde47e5c42d21b651baa03c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d554a1cf272b389c4e819640040b1081b846350b77386952c202473dc20c173"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/wgcf", "trace"
  end
end
