class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.25.0",
    revision: "c86ca00ab71a256d85af117f58e161cc55d20305"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7dd00909c2c6d76a088a5cd325927a359614e6bc3fcded51146bb570bcf7fb02"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d885c39acb2a1616fc547ecc8dfc80bf5f388d923cc011b35c557d7d8770845"
    sha256 cellar: :any_skip_relocation, monterey:       "14a16846d38171bcdd7814849d45e9f0381cf5b9a1f6f180f243adcf63c0b2a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "a73bf8b33b9f787ecd338ef786a0ef0826cedc0e116c27c2f594f99dbc63c979"
    sha256 cellar: :any_skip_relocation, catalina:       "3cfcbc13ca4ec71fea220be8b5d2d528a9f9fc7c623ce0a2414aedb7d94a512f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56895b8d75754470cbd67e31b9a1f9f184fb941b6120394ac73a133bf81acc23"
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
