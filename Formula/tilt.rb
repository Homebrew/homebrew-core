class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.30.9",
    revision: "ac882d4b6ab3c671de407e6413ae96fe6d2a8570"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a60b0a52433a3ee9b7dcac27b0d1b113dd21a529b3f6450b424823ebc4280119"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79cfc54fff9de7b3887486c3b36660c80e38ee87ead1293aa017d6d63d009c0f"
    sha256 cellar: :any_skip_relocation, monterey:       "a37f5773e04d0ae79222dfad7e0bb1daaae63978ac83565290920b6de47b734a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b082b346b2d82a4961f9c2ffd3731e847b8502a5a6402f87c3f5dac8cbe375ef"
    sha256 cellar: :any_skip_relocation, catalina:       "e6d956d1426e007cba22335bec3c73573fd7258a5de66e0a0a614cad74a4fe90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e982ce33d883fd5e4adc1ff99558a523723c087076437efe71cfccd97918017b"
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
