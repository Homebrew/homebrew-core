class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.27.1",
    revision: "e6048667d85c330e42a9e455d57cbbe535d025e8"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "316b9e6225e8061d08bd8eeedf4617aea55e0ef5bcc32b3d46871d813134091b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77a88e5c152ec64fe6743e016dd77af855a99c9be9b05f3e25b084056a99308c"
    sha256 cellar: :any_skip_relocation, monterey:       "63c7d80c44b6ecb50877fc6fb5df02000c9af2ffa8664c6c55dce4a779324e0e"
    sha256 cellar: :any_skip_relocation, big_sur:        "5799ff82a1d819beda4cb24d1f798cbcb214ad2be2729ece8830fda47481cb12"
    sha256 cellar: :any_skip_relocation, catalina:       "6b7809e8a4a44d1f4612857668a3b943939acf3ae75d0bf6e020e31ce535195b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ea3e2fe5193470ba03e1cd8b47b8f4dd18573093dfa8288f928db569288c2c4"
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
