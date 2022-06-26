class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.30.4",
    revision: "50984c5164a16906458154333265da78a6284986"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5acac8aa7df79ac20e3cc8abe6da7bfa336c02be39a132cb84f9aad4cd79403"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d652977660f412104948972770821b1c1f4faee8cbf0861530b926cab97cc403"
    sha256 cellar: :any_skip_relocation, monterey:       "499a17db531888aef4e68ca2d5af180da9ba60fc6dbaf82ddd4e8e7ece0de09a"
    sha256 cellar: :any_skip_relocation, big_sur:        "5445097d8944ad424643b205df94d5f6e142aa89002b226701b329ddaad69a53"
    sha256 cellar: :any_skip_relocation, catalina:       "91ff4b949b12659df81317b005ea86f1a780935dcb512428cc35a67fdddcf17a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5f8ea1350ed50843b86d10fea6b9f20f332f6bf8f15a8532ce2524d1ac65e14"
  end

  depends_on "go" => :build
  depends_on "node@16" => :build
  depends_on "yarn" => :build

  def install
    # bundling the frontend assets first will allow them to be embedded into
    # the final build
    system "make", "build-js"

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
