class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/v2.2.16.tar.gz"
  sha256 "f990bf8f08bab1390f2357324a79724aee40970845bef16b2281a5ca6b0c3b88"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e03e4149a53e1b315609f64aa7bdb50458f12f2d9900291defca04b6ddca0d85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e03e4149a53e1b315609f64aa7bdb50458f12f2d9900291defca04b6ddca0d85"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e03e4149a53e1b315609f64aa7bdb50458f12f2d9900291defca04b6ddca0d85"
    sha256 cellar: :any_skip_relocation, ventura:        "83ba32fa12f4b8f136c4cf60da047f9daa01df1dcf69486d720e129cba5b32e0"
    sha256 cellar: :any_skip_relocation, monterey:       "83ba32fa12f4b8f136c4cf60da047f9daa01df1dcf69486d720e129cba5b32e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "83ba32fa12f4b8f136c4cf60da047f9daa01df1dcf69486d720e129cba5b32e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72e0496ea10139890d0bf030f2b25a662140c3de8cf98fa648fe3917db79e130"
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
