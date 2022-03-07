class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/v2.2.12.tar.gz"
  sha256 "6945b032b9376f10167c6602f0ae3767f301b9b200c1aa6d543a874d91afbbc0"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2c9ab4ee5438ca27381d05b912f33c8ff5d83dd5429ead649407199f8ffe3f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b646ca15a17a35bb54438bd7bbdd05101645a16778a7cb148ed7079e376424b"
    sha256 cellar: :any_skip_relocation, monterey:       "30becd01302bbf87c4d5abc36c67c3fc15cea4d5876ae0324e4c9b86ed01a0cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "833f58fe2d6394c6ed4e3975e02f0caec437ad9c4b280612aef10ae778477608"
    sha256 cellar: :any_skip_relocation, catalina:       "cd505bdce04eab3c486056786d2c9f13fd69e035f8e57e903c35259002494e31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb2129aa956b1f937c285819dcec9cea0845683e082bcfd97bbe69f33e86d2d6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/wgcf", "trace"
  end
end
