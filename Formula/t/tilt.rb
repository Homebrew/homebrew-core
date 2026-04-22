class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
      tag:      "v0.37.1",
      revision: "411c6da9dc8f9391796ea40dc3c3268fc2fb3e62"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe3a0007b9a71741dc2ecf3a8f385be43bc36ebf94a4ad617546d0172ebfb258"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ac7d5849cc7b61ad90109cce9716fce10dcdbe6f3226038e222d25801756c33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11fd8a7e490d2ba9b23748910bdd525fc7237704eeaf53979048be4496bbd842"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7353638df042c1d1ca95f9e7a9408459ed089626681a4dd8ff27cf7c92ddd7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a9e5031bb136a969fcfa95b2fadbef0427d02f36c51e04e10f1cb29cbf3a6d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b61a4f68bb59de92cbed2175aaf331f9fe05ffd00f0e0830c9b48ce79eb4cb6"
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
