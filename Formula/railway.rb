class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v2.0.8.tar.gz"
  sha256 "4dfc6869ee125127741ae5182163698d7072450eb1c37f173895a22273bfcdaa"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "878619c4be0b517467b4061e43c3a2a1f9340b8f75d5e7794a3980a619e39ba4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "878619c4be0b517467b4061e43c3a2a1f9340b8f75d5e7794a3980a619e39ba4"
    sha256 cellar: :any_skip_relocation, monterey:       "f5d86fa92b11a33f05520271817f2b12a27146d99236692953d943a2a06b15c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5d86fa92b11a33f05520271817f2b12a27146d99236692953d943a2a06b15c5"
    sha256 cellar: :any_skip_relocation, catalina:       "f5d86fa92b11a33f05520271817f2b12a27146d99236692953d943a2a06b15c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9710333a455ef382d3bec605a25565e20f863c517e1de8b2529df25bf92004c0"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X github.com/railwayapp/cli/constants.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    # Install shell completions
    output = Utils.safe_popen_read(bin/"railway", "completion", "bash")
    (bash_completion/"railway").write output
    output = Utils.safe_popen_read(bin/"railway", "completion", "zsh")
    (zsh_completion/"_railway").write output
    output = Utils.safe_popen_read(bin/"railway", "completion", "fish")
    (fish_completion/"railway.fish").write output
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1)
    assert_match "Account required to init project", output
  end
end
