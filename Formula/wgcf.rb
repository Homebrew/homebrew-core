class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/v2.2.8.tar.gz"
  sha256 "1e151d8d79b3cd9f3c245ade69282a2e9eeb4414837b99de1b845b21e9952bf5"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "24cb73d9f889eba705cd7d0f70375fb0a5e5ca362d04f85d9df65d747e2c1ad7"
    sha256 cellar: :any_skip_relocation, big_sur:       "91e404ab2933ce85a85e135115ce28924f738dc2be1f4f6108892cb1357ae37d"
    sha256 cellar: :any_skip_relocation, catalina:      "197ae5f4428256cdc4ef3854ccdf4cd13836570fd141f5b6505f29a19496e34d"
    sha256 cellar: :any_skip_relocation, mojave:        "c75eb177141258d5d5d0a72bc99935948262a4d36ea51596229cd7d38aaef128"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2519bef244b148959fd807969111d7dde714f07f302ee26c4b40b00746775522"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/wgcf", "trace"
  end
end
