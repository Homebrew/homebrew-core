class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/v2.1.3.tar.gz"
  sha256 "cfc042ff45d627e0d80e2ea3d0e80551dc72955ada126ad0c1385e2620939d82"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5580af3756ad75c1b9d94ba6cd391a7f1fbc25ee6992fd8d101911f04771ba1a" => :catalina
    sha256 "a206036aff8dbd8afe9196fe0dca8ba510dbf39bbd168034a7be97de914495c7" => :mojave
    sha256 "9523a32e151867029d17ecbe66813b4961e594613ca397b61b869961b1b1f29a" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system "#{bin}/wgcf", "trace"
  end
end
