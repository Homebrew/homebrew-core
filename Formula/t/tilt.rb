class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
      tag:      "v0.33.22",
      revision: "cf2aeb6b71095e6411e7f31c69e62b51a1df6e59"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b45357566c67648cbd4bb20424c233a2001aa99b8a4d849cb3d97daee3972e69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a438a821b54c66dbe7e47d8dc11ffa86f32ce429a68b570771d5cfa8ed702908"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "27bc8335ab9bd9dd678344e99396d838df574347f56b746be4dfb8cf2a2ecf9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "79db027fd46308fe2a990cb88877b541e2609b2df1ad3cdf485efe90f265e247"
    sha256 cellar: :any_skip_relocation, ventura:       "cd977ff5a8a8a9c91864087091af44cacd0fff51d710a3e436e1074a8252a5d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c65bb536c401c5f9c21eac0da0f1e5624ebd7e1f08129820ce8fac7c2e4365f"
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
