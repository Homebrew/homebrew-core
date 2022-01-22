class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.23.8",
    revision: "089f6e0a95392f1143656c8d4c59c3ba1996d806"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb606c853b3f5e98c3a7566a0bb280bcf153f6352c4f647222623ffee2f52527"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f41839d74c23a25c193bc3c279ad36e38d63cf3b811a877b6edb8a21b8592b6c"
    sha256 cellar: :any_skip_relocation, monterey:       "fe3774e9660a51a60e263bb9169cfeaf47b19b3d6694be39606d60913857af58"
    sha256 cellar: :any_skip_relocation, big_sur:        "585456328fa6ab41f37ad777ca29cc82de7e082401f5a2b31cada492ce2c363b"
    sha256 cellar: :any_skip_relocation, catalina:       "ca6dda99022d771e659fbdeefcf283ccaa1b213bf1f4317a37ba35c082f6e1ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47c2539509257ec08e216a9049ea423259adc72d74406a00fb86f18b6fd07cee"
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
