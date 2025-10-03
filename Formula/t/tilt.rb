class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
      tag:      "v0.35.1",
      revision: "6656b4967d09714fbc01592f2c7247efb7dbdfcb"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62d3e5f4cc9e608b1aa503b30779ad60d8a21174344cb7993ec5eee95abe8c76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73239b26337ceecbf8183bec6d8c8cb785029c77b755550dbc9d70c30696c85f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "085aca1affce3fc6d3f70bddfbff405cb13fdfb1e7ee0d1200b037710c5173fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "35a5c16e83a62c326e08206237c808113881742ec509ce42dbdf5ce440d5d8b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec95be490cb1dc3487e4b17ae7708bbef51e7b2abe15b0f7c04f28a58e512f3b"
    sha256 cellar: :any_skip_relocation, ventura:       "e3ad53989f9762b5c4648a679dc24112392581ca318a799382b8c69490efeff5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5916d4f519670b98748690f5950b104f68417f4be3d6206880def6124aa855a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ed6e16225e9927f6b7c1112ad9c34a5253fbdd0bffa4ad4a6c07071d7b74cbe"
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
