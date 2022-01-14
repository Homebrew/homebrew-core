class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.23.6",
    revision: "5f22972fe19de54b3d66e31b30622adf056fe6d0"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8e4d2ccc5ccc8279b8d213fec9c6dcca82dd2e6e4be64d2c4d9532b07715a52"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a414090100c2dd4f9a1df596d6a57f31cb380fc6fcf57cce2396731f46f84385"
    sha256 cellar: :any_skip_relocation, monterey:       "092e0f1e0508f3b894090f099ecd8ec4078025612161a5268312df5a42146163"
    sha256 cellar: :any_skip_relocation, big_sur:        "cea75af86f597dfa0e85038804e8815ee29add34a836500a0fe5eb1a990c3acf"
    sha256 cellar: :any_skip_relocation, catalina:       "db0ae7408e5a5bd8ea12dcc6de1bcb34aeda397a26bbbacaff1b42485ca1f110"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92360a3e12aa33c50df698121c2247c010076998c3269a7a618980b4d9f44606"
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
