class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
      tag:      "v0.36.1",
      revision: "9e4ffd18305728b6e18b9cd8cd942c12ecfba010"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fcf7400d5029b4ad58e2de0c1938ddcefbcf0e90c94af8b8e625cfaf68c7813b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec58011daa11e4e365d69a34bc2685cefd0a40eb7a89b8a98be52b1cc8a88bd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0865c73c0da2121d665b69a3bc0b43bd78bf173da27603e1af12cddbac5ac65"
    sha256 cellar: :any_skip_relocation, sonoma:        "70236b0821e389b046591fb2f74d44180ccec35174912ec39411d96619932f6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02daeed859805b96c37c587323de121cbbe0b38bcf5906acd4c51c04bc6a9344"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "186ac8d4d5cec8c08ab1dc2009855c0f725a324235981f62984b308220120329"
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
