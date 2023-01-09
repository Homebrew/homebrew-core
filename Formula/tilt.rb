class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.31.1",
    revision: "72e0e98f54390a39c4812a8d2dfdda4b6889b406"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb0c23a914c13b9a124a70f55c81ca6fc7c26f45fb57149bab16fbc9ad5d14d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0aaf548b7bfa8bc1312414a574173feb0c88485d69dbd1df2c5d9782e2bc05ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54ce742d5fadc9b1d27ed937992cf02fef8624957458b2bd9cb78539e3b6eb5a"
    sha256 cellar: :any_skip_relocation, ventura:        "083bc23981f445fcf92327b457e98a76b1064bc83c62fc49ac869fc16a61d374"
    sha256 cellar: :any_skip_relocation, monterey:       "a9db0629862771598eec1ebccf13ddfe541d202c6063b7465d6c02517321ec36"
    sha256 cellar: :any_skip_relocation, big_sur:        "899c2b2bef267d812ee1e889ca872ff8049708bd834c8b5e36122220601f4496"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7cd3a1b759566d7fa6fd3d6136e1f4157395d3064f6a82c69e177c63d4a900b"
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
