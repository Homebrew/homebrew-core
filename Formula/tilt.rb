class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.23.0",
    revision: "d3ebf7fb553a58f7ba90afb969c49b9c029e9fe6"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcb45daa09a2ba2a99a7facf806442e3ad9e6377a8943cb3e7ba7ca1f3105149"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f828931d6e4a89a5a2dcff7b1195acde58afe6af6eb3274d28b07b693803544"
    sha256 cellar: :any_skip_relocation, monterey:       "ba06bc05ca9e9e3a2bb3a61e299e6b34f2e98cdc884f63f07ab3b314e9df062c"
    sha256 cellar: :any_skip_relocation, big_sur:        "819961e1dfda3b5292d6a4ffa6623a6ce30b58d1b98037aa750577467241b9a0"
    sha256 cellar: :any_skip_relocation, catalina:       "f9612a873440f27a7a6e98fb8c285ae670de5dcaa69a4c01f84826067b094f19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eabfd8a07710244758f9e1786d31274c89e8e6b970b06246b83dc022bb55f804"
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
