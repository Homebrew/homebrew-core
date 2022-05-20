class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.30.1",
    revision: "b7382fd509bc2a3fe0fae1e16820ae58ddfc4b39"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e42ae0ee84b82b5d1741034a10a9c0447523aa3e931903a96ae379ac3a16330a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f5a8a56642993e55f469e9c57b8fd1f082f4abb4fd09e9cb5a330670764ea8c"
    sha256 cellar: :any_skip_relocation, monterey:       "de91b4b87c8edb437c586a95e165a19ad2425614d3635cd60d8a106adcc36396"
    sha256 cellar: :any_skip_relocation, big_sur:        "73e604d805950501ecd762f62260c838048efe9acd8142fdb08dc1bdb68d3abe"
    sha256 cellar: :any_skip_relocation, catalina:       "809c4a6886f19cbd893f78d0520d0ebd119de031c0acf83eea9e1fa7a0e1ead6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "222aab47f514ce587557e2c5c16fa76bd556ec4067c8385efeb381d2146d0612"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/tilt"
    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/tilt", "completion", "bash")
    (bash_completion/"tilt").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/tilt", "completion", "zsh")
    (zsh_completion/"_tilt").write output

    # Install fish completion
    output = Utils.safe_popen_read("#{bin}/tilt", "completion", "fish")
    (fish_completion/"tilt.fish").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tilt version")

    assert_match "Error: No tilt apiserver found: tilt-default", shell_output("#{bin}/tilt api-resources 2>&1", 1)
  end
end
