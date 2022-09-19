class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.30.8",
    revision: "a47c07ca1c06e5304221d7c2d34b90fa0b5623d0"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7701f3cc43d9de4c0fc847b4ad11e6f21c8dfae824869e9046de4c36079ac779"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b66eb433425ac7c8b79ec343e2eaa90227b23b7fb6f0ad5d3909872ce543bc33"
    sha256 cellar: :any_skip_relocation, monterey:       "d067f6dba01f756436cfa59e7952e8b5b4aae8e57d277e1a52c23d0a5b6347fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b50d10e67aa535c542c6fb875297f1749cc45f26885c6ca788f669d91ec43b3"
    sha256 cellar: :any_skip_relocation, catalina:       "eb9062ca30d8d843f796812caea7439dc257a0ec794f4f17419650c4ae8ce8e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e642f946300069b3ff8a288f23aa60ecb482446dcac0e24963ad53abd9d74599"
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
