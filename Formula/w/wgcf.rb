class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/refs/tags/v2.2.30.tar.gz"
  sha256 "91dae7e063476486643bc20005fa764380e2a3b38f42002b4c5e17da637bafba"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09a2d9d054df9f938a6ba1a2c6e78fef704c042cefa20d624d30814cffb1d659"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09a2d9d054df9f938a6ba1a2c6e78fef704c042cefa20d624d30814cffb1d659"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09a2d9d054df9f938a6ba1a2c6e78fef704c042cefa20d624d30814cffb1d659"
    sha256 cellar: :any_skip_relocation, sonoma:        "abfb16110ebfe84fe340587f1e8f3e674094c468b4b14a6159325667e899dbe0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11e09aea187b8d8e88cc2c4846cf3c49aab45e900922b56b32cc78f3485e8079"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ae80ab0bb56632e4a8249c291db64c5143968422ec9548c7f87fe371d52b05b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"wgcf", shell_parameter_format: :cobra)
  end

  test do
    system bin/"wgcf", "trace"
  end
end
