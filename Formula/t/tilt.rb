class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
      tag:      "v0.37.3",
      revision: "dc05fd90e17c644254c283cd54f8674dd41f7790"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9dc5d23b09365bc09f5d25f49356840ed4a945eb1e0c4544dd718f4d3359a15c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8627e737e67ed733102d95162bbdc7d1fe7728cd0a9cf4d4a9304fe56a5c7804"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2c69759f14dbb59f1819e85726e5d2d482e1cb7d56b86abe666afe8c8f2c795"
    sha256 cellar: :any_skip_relocation, sonoma:        "13e5c53aceb82ba7b544cec36eba6e449c900f75ccabbf0e6df85f13c4678332"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d37a612ad21f91ddb54d73039a5867ec4e6d3d68ece37fdb9ca6e28fb2f7112"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c170e16f00fe62c341a932244461a9f0db1bdd43773eec79bbbd4d25e2a366a"
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
