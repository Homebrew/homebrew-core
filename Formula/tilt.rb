class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.32.2",
    revision: "e38e4a261ba0af8b02eb67a839f0efea169b150b"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c891ece48379ee1f391330223b0440a24021dd7bd968564aed1b99823111d13b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b99f6d2209c1988aa6d21a28d985fa215ad58239d332568200d176ef219b7dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb623408079f404e270e87110ae3098512755b2c0ff2ecd77ad36bf2a0d7309a"
    sha256 cellar: :any_skip_relocation, ventura:        "e2184c67b486a6489565418ebb8ead0ede0c50af56a1be1a517e62edac8a432e"
    sha256 cellar: :any_skip_relocation, monterey:       "884eb62606c2d88d726a2d57dfb711a451f8d41b853874fae15a2e76a40973cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "80338b89a4ed4008762c97e4d55b29fe5742fc75aec15450dce90b51497e85c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78280efa37b8a6f77f47203294ef3f7088df28b94654d12cda1dd1a3c861de81"
  end

  depends_on "go" => :build
  depends_on "node@18" => :build
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
