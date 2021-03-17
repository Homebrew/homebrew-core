class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/v2.2.3.tar.gz"
  sha256 "c65d70fd9bbfd65d74676c36ce3b234c85ad6b8b576e4358dfb9ec2adb773b50"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "75d7c90453127ff7a4eb4004ca09f7095b9db56897d1d07eb586a005c3f6a7b5"
    sha256 cellar: :any_skip_relocation, big_sur:       "df08d54a8c03f9611a8c93c136c5cead470434b260d19ac2dd248ebae811d5bd"
    sha256 cellar: :any_skip_relocation, catalina:      "f2b1614c88ade3e466d68d4ea61575b078d83c1e2cd8c7ab2a90351c8aa41504"
    sha256 cellar: :any_skip_relocation, mojave:        "c8adec4341ad183db2d93d5ce21178396c8e800cc2f52c36bec6f01debf2366b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system "#{bin}/wgcf", "trace"
  end
end
