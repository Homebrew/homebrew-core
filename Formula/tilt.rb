class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.30.9",
    revision: "ac882d4b6ab3c671de407e6413ae96fe6d2a8570"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c92a50cdaac6aa4da12d30a4ec26c527794185cfc044ecb40f6f90ebb74914cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0aa2d06001919ec78734e12321c0efe316149f6477b86ec1b8e596775d00bdb"
    sha256 cellar: :any_skip_relocation, monterey:       "c712409c29beea6c9dfa6fd0200327259642254117781198f1971438d3fec750"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ea91050cb41810b7c4b599268de2b9bec01ba6e459a961996c849f4d1810d55"
    sha256 cellar: :any_skip_relocation, catalina:       "3d4f003d9b66e2a8b94d3c8929116066bf8e91a13375a0ab535a3478ef9bbc83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23355561dea757600cca041d8e924e3165071b7b2d1681978db7b6f1a58ecab4"
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

    generate_completions_from_executable(bin/"tilt", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tilt version")

    assert_match "Error: No tilt apiserver found: tilt-default", shell_output("#{bin}/tilt api-resources 2>&1", 1)
  end
end
