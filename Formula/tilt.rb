class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.23.3",
    revision: "a71350c746352224017049deb9791c5d12ac0707"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "867679eab9a1457b61c3f90e483b523d9c883092980adad7f0cbcdfb4167a52b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29f5891fc4ebe2e24cf5376103de1f8463b319439218e0a7c9751d59c238ed15"
    sha256 cellar: :any_skip_relocation, monterey:       "b32620f3214fd190cac1c42ac0809b64dd4d8a2a4ea6d8d6ae5d7c00f1f8940f"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb72a565d7fdba6668554c3a28cc4a45a011ca61a6c727e4098e62f5388e83f3"
    sha256 cellar: :any_skip_relocation, catalina:       "073c715505d168da31914c9e3ac6a6f61082ea6e18c986214e4807a4fbf1b9ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10e486330bf3d14973180332fb2bbcdd6d6710700c6fc3327beb83c878df28a8"
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
