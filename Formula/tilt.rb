class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.28.1",
    revision: "7acc38ab66b06aa317d12fa31984886c469073a3"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a1f6460047516b98a0f088df5321eac84c451fa188a8ef72e1edd6e06f2c25f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4077618c02572c7e8ed971d5bd97f2985ac2c03cab582af469357d603ada6763"
    sha256 cellar: :any_skip_relocation, monterey:       "e05ae46e1e172397660a7d288d765f666afe39f96b47b108313b41af0349fd8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "c7cf2f6267ee4433a0a64837596146696d1ce3536b165d24c78181b6b0b01c3a"
    sha256 cellar: :any_skip_relocation, catalina:       "9edb34319437152f07902309cecf4e3f9a460bbe5225744195385fdbb343b797"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cc194741a009413538f95eeeec48223d3c57373955c89069be40b7b10842bda"
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
