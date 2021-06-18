class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/v2.2.4.tar.gz"
  sha256 "518ab709692bd87e2d6e4c3baff1cc09e5239f942ae1762fdb19dcb664d475fe"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "661af7987b3d6cccbb1411ba153e0a6edaac1a5b98ebd072eadf483308debf89"
    sha256 cellar: :any_skip_relocation, big_sur:       "cd7f1f650844daf0fb7e3c2bc921248605c76df817119a0a391205736ea783f0"
    sha256 cellar: :any_skip_relocation, catalina:      "0bdecda45a9f085e3ca91b04b410a64cfb4f45ae1ff13462c5255de9c075f184"
    sha256 cellar: :any_skip_relocation, mojave:        "f3e0cb8c6e4173db279ddf93702dbf63b56f602836fb80eb45c892bd42db536a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/wgcf", "trace"
  end
end
