class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.26.2",
    revision: "c284515619b1ee3fdac16c287423deefaefe5c23"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "326b035a62a167285b93e3d1f6bdfa6b155b336c2bd60bbcf7e20298a3cc0aa6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "905e0af106468f1304e8f015686c3d0f8ee95a7d5130f203b32402a8cf357bb0"
    sha256 cellar: :any_skip_relocation, monterey:       "a366278df98e1d60225b457e5a762d6734f669b0e2fe780b94a48e5fa846732b"
    sha256 cellar: :any_skip_relocation, big_sur:        "feeed550084ae77fbc895b23f5606e1adc0d0ae66120a4a1d3561a0529337bd2"
    sha256 cellar: :any_skip_relocation, catalina:       "084778ac4bca53797311579426b66828aa52895151b33bed0dc5c8673acff2bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "919db6d0dd5c5c3171ff25e78e20ebe2d82073ae23753287add5f61a71b5aee8"
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
