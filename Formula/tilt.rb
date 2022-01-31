class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.23.9",
    revision: "a7112ee78555429d1b26c882d1f318cf2c0eb205"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e86a8ccc2910afdf03f6e4a3c744e86bfc05f21a78979d2a5bdc479bfd75b62"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "649bd8228c2880212bda527b342a098042ae714cd004f21863da5d3587b8d21b"
    sha256 cellar: :any_skip_relocation, monterey:       "186757e5a51d1ffcb20da79f38a3a326a8a65a71b299b959201d5e27dd67a150"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2980719d28686b5b25d78595c5b1b2599e3d78071e70149987d7f8097d15c4f"
    sha256 cellar: :any_skip_relocation, catalina:       "44a9389dd200bfdaa6c553ad3800fdc91c570b7df504e91266583fe14173ec24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eaef059c4609d3383a63663a6d532d468da78e71b1cb8674c6bfe0bf0afbc123"
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
