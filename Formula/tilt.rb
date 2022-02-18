class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.25.1",
    revision: "b049a24a06329566757cae42408b54fc22c4e9c9"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f80910d36a4e0e991c108441b166d842ccfc1b8e3381def13706702b09ade2d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8dca707badc7d496eeed7ab05b11807d581157792dc93ecc5910a62fcfaf725e"
    sha256 cellar: :any_skip_relocation, monterey:       "c06fedf3b632c4bea7a4313c99603868e8c011cbea04372a8a023faa06c5eb3b"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ff4f0917b0cebf79045fb0b02ae4be2244b8496bde66e1f0e4ce8eccf784af8"
    sha256 cellar: :any_skip_relocation, catalina:       "4b88da9dfe5ce1b88860cbed18ef5bc71f417c46ce5feb5324592e3748c13063"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd16b0e85c250c18c20f42c2927a454f6f4276046bfbc5e5b3403760be6d5d7b"
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
