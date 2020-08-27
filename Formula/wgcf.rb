class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/v2.1.2.tar.gz"
  sha256 "33e45a4720b3217fc413ba890fc111646a6a4c3e19370cf2a1d54450e4dcbdcd"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "98aedcc0ea89206a598ad085bdda918ee87e7fd4d0953ea61bb11ee413425907" => :catalina
    sha256 "76b8267b99558a8d59c633dce247b6c59fca66346fbd754c6ed13635efbfbbf2" => :mojave
    sha256 "e8f1364e5ab689ccd79a48157f1913ae29d206f9ced7cececeb56e0ddd8177bd" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system "#{bin}/wgcf", "trace"
  end
end
