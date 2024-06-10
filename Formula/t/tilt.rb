class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.33.16",
    revision: "c38f0fd431304ee860fb8524023a0b5343ca0160"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bcc4f1a59f1076b9a5c1e36939052ee76fea9342b0f284d45304ad3a363d3c15"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31f7007d7f1f3f7c269251e7de71ea5f0f87b05f5ed4fbb113c17a89b02b8215"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a220687aeeb58a740c7ea04f5bd840cdbba0a9243c71d20c906bcdf2497e13c"
    sha256 cellar: :any_skip_relocation, sonoma:         "d4ee441f6417692742305ce2666edb00f6b01de7eee7e8c6e6c0093d34d8ac76"
    sha256 cellar: :any_skip_relocation, ventura:        "685541b5718b6c11a6d213f038a60f3e54536405a896fdce04c349081e042976"
    sha256 cellar: :any_skip_relocation, monterey:       "ccd04cf285f1facf47d9ce111e8e9e2be3d68cb374364f279c7766fa3814fe17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee77d57959405337b5e13b4220a9c6c2efcf7d84a0515a142c5eca2c17a10e50"
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

    generate_completions_from_executable(bin/"tilt", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tilt version")

    assert_match "Error: No tilt apiserver found: tilt-default", shell_output("#{bin}/tilt api-resources 2>&1", 1)
  end
end
