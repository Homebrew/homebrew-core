class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.25.3",
    revision: "5e63bc712b8089ba96c4f2d7c08baaabfeecb3ad"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53f298ecbf42c95917379b6cdf16a82d5b8cb8f65be65a4886d6dd75896faf1b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "380a54ace05ff32025050a97ca5d5019c4e841e48a87670200e0a4190573b841"
    sha256 cellar: :any_skip_relocation, monterey:       "bb2ff665985f50e390f17e50273ee28bba289757c456fc3d168934fc211db285"
    sha256 cellar: :any_skip_relocation, big_sur:        "95a5ee6197f5e5da2dac0aa4545172d6fb4d09b22f432e7651d4e9e2cffb27cd"
    sha256 cellar: :any_skip_relocation, catalina:       "66a470f5b923ad8212499fd1d49cb446109fa5539a015477989aafdf7d2d5506"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2fd49bfe4f664f26fd967f4418b25f9c90f3b52885997326f8ce6944c53d301"
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
