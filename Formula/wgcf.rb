class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/v2.1.4.tar.gz"
  sha256 "15250cca4e8f37dc9d6576ea6b0e039632c59d930cac1f1b0da40789122df062"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "94872893207ebc688892b960271ee100e1ce5a6dc73dd6195bb2756d3a5aa344" => :big_sur
    sha256 "e2acc4515d744c2d7bbdb6ac5935529fffc8ad327134e85e0455cd39697b3537" => :arm64_big_sur
    sha256 "c8f35565606c6fe3cc7b79105076e4d8e1106950cfb0ab3fdd184b089e5e94ff" => :catalina
    sha256 "1635231fe27fd9dfa0a9202dcf266163f131254843de7546e2b910800545a140" => :mojave
    sha256 "0debd1f07625d225e2683b95a158c2d537a3ab7bae64335b6a3e4dfe745bfbdd" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system "#{bin}/wgcf", "trace"
  end
end
