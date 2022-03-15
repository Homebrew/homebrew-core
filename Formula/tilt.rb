class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.26.1",
    revision: "dcc71d6521108ac75236b94d7f456223fbeb88cb"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6140bc5a5f8da53a48e41baf5d1bb03cecb601976aaba27ad596e8dd17021376"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b762d137c881838b6d5115acd016bf28d048457bae2eda952382ac3197bb9d9"
    sha256 cellar: :any_skip_relocation, monterey:       "37915e4c213c47e46ba70c36eedbdde5fd1254ef7707398d97e45b4a7ff45b81"
    sha256 cellar: :any_skip_relocation, big_sur:        "c7b1f39be86dd5b4fd17ed11710b20a00775c9f88716f502de1acfa54f2292d1"
    sha256 cellar: :any_skip_relocation, catalina:       "280b4c8b698ea4a79751b5dcbcb1756916ee9239322ee16a564f8fca7c4bffe3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3d5b5a7ddcb1915d662890163f8d8e29a88e51f17e32f7bdaa936aeeec4ef35"
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
