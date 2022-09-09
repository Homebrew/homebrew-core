require "language/node"

class Rospo < Formula
  desc "🐸 Simple, reliable, persistent ssh tunnels with embedded ssh server"
  homepage "https://github.com/ferama/rospo"
  url "https://github.com/ferama/rospo/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "967c0bb1d7a10686e93131e6cbbf586774f4f9f7f0bc52b5e6c3a62639a4c31c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26f3f6cbb2f9a6d24cede64aaf5e727204091155800d140990f77b3fe2efd22c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6f7612d30432432aab3771c269a7e2353e00b0966d628f8cc4e3eda6b0976dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3117dba9f0f17cd64f441f3d83cdeca61d3f32a843acf75b3f4dc86c3a97ed07"
    sha256 cellar: :any_skip_relocation, monterey:       "fe371eb5b655ec6f9a6053521da39f2ef13e9345834d1dd4487a6e8f8e8b0963"
    sha256 cellar: :any_skip_relocation, big_sur:        "245063169087e0c2639d32c0f1d529a1895dd81fa3ac93cfe259fef26f939b8f"
    sha256 cellar: :any_skip_relocation, catalina:       "b0b184a60b404c55b41290d7f2182db523d58495f77f64d73845b816afdcfc8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae5bd8307c535f20a7f2fa3423c496397fa0d1578142328d1fbde9c0e67555ea"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    chdir "pkg/web/ui" do
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "build"
    end
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'github.com/ferama/rospo/cmd.Version=#{version}'")

    generate_completions_from_executable(bin/"rospo", "completion")
  end

  test do
    system "rospo", "-v"
    system "rospo", "keygen", "-s"
    assert_predicate testpath/"identity", :exist?
    assert_predicate testpath/"identity.pub", :exist?
  end
end
