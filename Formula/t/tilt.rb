class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
      tag:      "v0.37.2",
      revision: "37ea6133b2bc8897e2ed0ac14d5e263885f8658b"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2247ad8b6fc1874f77d3546b805ac075a2e462b1c03c9153a05c5b0555fd79d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b0ed47978818114119f065684692746d34719dcae9691fcf864e6f9ac898c3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b919b9d6c2270c4de7f3e5a2c7c7ce65c53c3f6d61174254ab39445e9998b7b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "42e5d98b2a2f71ea6e8cc6379f2278c75e52fc1f3e02d37666ed7146b24f6e7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b1a2d36f3b32e2e7143667179458b1dc49004dd0ce6c26437645de0834fefca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be9aa558db063b4d7b32a06bfa6f263c44900774cb0340f43cd55e751a28ccca"
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
