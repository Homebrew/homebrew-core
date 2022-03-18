class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.26.2",
    revision: "c284515619b1ee3fdac16c287423deefaefe5c23"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa0f831b652430cec3444e126c5172cd1015e3faee70886157e4fe7b31a5b227"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9277f9384651493e5b570a1178ee2b3e7d469c8d8625106aa64b547ec2f52420"
    sha256 cellar: :any_skip_relocation, monterey:       "d8df0b0537efc449e03efd286b0b6ef4181211fb3dadcf70677519cad46fde15"
    sha256 cellar: :any_skip_relocation, big_sur:        "8500a83c04838133a2fac98f49ecd9eaa5dd97a6fc918bc22776049a1348a59b"
    sha256 cellar: :any_skip_relocation, catalina:       "d57ad0ea6e1681fda2233fd13b074c7599b5af8817a99848be5b604b943bb7ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "027731d61a537bc655a0cf9580ab781eb778611aaffa01af83ae5acf6bbdcc73"
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
