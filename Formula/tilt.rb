class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.25.3",
    revision: "5e63bc712b8089ba96c4f2d7c08baaabfeecb3ad"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fad1f17acc6caa65ae062eb8f99c9752919b6e4c33f12be866a659a026434640"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aeb639689545463c6a90ec751843476c91188ade42345f39bbcbf5441cc6913e"
    sha256 cellar: :any_skip_relocation, monterey:       "6567d314fbf7cf66df4388864041c1ab9aaf5a4ad4a68c7d0b1831b659e10090"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5da0ef66ae14f1d1ccd038a35eaa58074e62d65f59080d4c9bbd3b9b7acea14"
    sha256 cellar: :any_skip_relocation, catalina:       "c8cc486050dc630b637cf6ff86207db7030d62a186935e19a8e122a56c1a4fae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cf727514772189121dd752da3442e523e38df9ad3972900ddcfb0401d0d4cb2"
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
