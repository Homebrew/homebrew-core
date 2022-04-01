class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.27.0",
    revision: "2d28fac9d99015bf2ba1c87cd09eefe40ccb9019"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b90aa0188dc7fb277d58bdaca645342bf3bc895d688159f925e59dee01abbd2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97e25c063822b48ed3d3bf56db9643aa189e5a2ed91257ca4d80a2697b77876e"
    sha256 cellar: :any_skip_relocation, monterey:       "cbcdeb0495409f2f61cdee9a9cbd3bccbc8c320e8feb43de747bb4a607fb54f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "622f2fba3ddd57dc611335ca5203faf2b4fddbd9717bbd7ccdb9aeae99c500e6"
    sha256 cellar: :any_skip_relocation, catalina:       "3c8aaefdfc59a02ffc24a6c834d7f3b2cfa37fe24243e464e7c48e6e7f148050"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c925efe65361511337d719c389123c6f329cd48f2d005d3c3b23997b4d457919"
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
