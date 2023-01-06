class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.31.0",
    revision: "f53e57313538a39ffb0c6e9dbd0b33cfc6cef590"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbbab2a54b57081649178b9068694ec0e027f96d6be19964b3964db973a3bf21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "976c269929c14666abbd0f27b26ac28405dd32019f7e73df9d1c55c8c24af534"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d4fcfaf4277969b6221ff3c4de3516bb33b30c0a5cda10e0cabdbd749558e81"
    sha256 cellar: :any_skip_relocation, ventura:        "de84b1c16e264efd5ed0835fba8b87a6d81dc2d8d365d58217c7f62ddeda7de2"
    sha256 cellar: :any_skip_relocation, monterey:       "5f12fdaccadc23355fd7e26ab398495e9951a290099c937c4fc7b36eaeaca74b"
    sha256 cellar: :any_skip_relocation, big_sur:        "b79b0a04589d251a3f483f672ea768aec205a9f2fc15a8a8e9bd92c138f75717"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23e2ca84da2439859c9250ba381a5f1d5352f34a4df69db51c6a2b67d9c11927"
  end

  depends_on "go" => :build
  depends_on "node@16" => :build
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
