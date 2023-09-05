class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/v2.2.19.tar.gz"
  sha256 "276bd779224ec67c2710c4717a74c67a5c7a9455805457b385d9b8d52af1cff7"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9afcf3cf0ae873a9e90d2a9acaa81111e2063126e27daa33f152d8bf25041f75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61e37a09b0e10193f7aa9517512b1f3a667e0d17f99bcd176b6012fb76655345"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6c83b999555495f04ef958acde349c7a55ab85246d7c223015afce0df9cc22c"
    sha256 cellar: :any_skip_relocation, ventura:        "57af29af6c967821e84ea90c3cdfbc35d432893460b41791aa40e21bf89fcbff"
    sha256 cellar: :any_skip_relocation, monterey:       "aae0bffdb05bfd4da111262ff06a18ff6daea7b881251629f907355061a2ed68"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3adfd03320dbb26eaa5fc1d63ecb7c4064dc6c962e908903731c00923816b01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1677aebb8be3ef34c820d1a07fe1a5027206df64f353dee2c5c18308eb52392"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"wgcf", "completion")
  end

  test do
    system "#{bin}/wgcf", "trace"
  end
end
