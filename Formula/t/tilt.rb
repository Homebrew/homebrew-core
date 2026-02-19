class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
      tag:      "v0.36.3",
      revision: "7e4dc61fec0c7c4986a53b93f19214459b4f18d3"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c241dbbe59f478a333ca654989771d898af022fc711ef8fefdd4ed08e3f88df0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec6d3537d7288ee691ff5829f274b7ead8e52afa423b7481663e5cf31840e091"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1704f60b56b4e2ae3c5e35c05bd6a8700a53931ffecbd78ad25cd8c18d03bb10"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c1053002e926d32ac69dec9a4206b1b41679a216f557a1bf113248d7ddd1943"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af03e6137b16e0cd93ae651edcb82425ae397cf8beba7ed1692f2a4bdb0ae19e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37e54f7c82668d5deb0083e6610010b2845077068f0fce006588f8f6b4ed3f13"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    # bundling the frontend assets first will allow them to be embedded into
    # the final build
    system "yarn", "config", "set", "ignore-engines", "true" # allow our newer node
    system "make", "build-js"

    ENV["CGO_ENABLED"] = "1"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/tilt"

    generate_completions_from_executable(bin/"tilt", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tilt version")

    assert_match "Error: No tilt apiserver found: tilt-default", shell_output("#{bin}/tilt api-resources 2>&1", 1)
  end
end
