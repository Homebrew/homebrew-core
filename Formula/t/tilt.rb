class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
      tag:      "v0.34.2",
      revision: "a2631c109837c74cdbb35121855b3bbcbe1ca53b"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e2e9d308918a42f9ef6c172264e0c0e205f9f65b176c5eb25c535e8a6ccb2d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4613d9d883f6d60c1994e2a1b46ec8dfe0f80bc9220e6eefd38e6953b29916ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fdfad6a476ae2f2cc8995ce5f686df51ac9737e7e7c09b9cfad93c2c23ccb605"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ea3b4f163d680b2bf1f1b83e7e0001b224f6fb11895c12b8726098ccfc0851c"
    sha256 cellar: :any_skip_relocation, ventura:       "9d26dfbb67d69fac313f53a1cb2847be8a8226b7acb417d1a96455b578191789"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d96f7f6761757756edb6acf12560177b9a52721d25ce5785a7977dd4bc1664e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6049a15825f7ae05d8bd84741ddbf7f76e7b08cf9f1b907f3aa82383b7b25928"
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
