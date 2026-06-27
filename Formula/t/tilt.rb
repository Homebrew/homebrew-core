class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
      tag:      "v0.37.4",
      revision: "0b591662e013ba2d551d4861009d7b3c2276c90e"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2daa17f53be87dc230aec1c8973dd54e941a9379ea7f31cd7bd79a3ae57007ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "587a31b96c1aba3cb6d6e9887dcaf15fb82357231776f48c5219dea9cb998198"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e848382e13bdf4d1d5c570a0a895ac4563e42c378b3c358076c6965c9992d8ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8bce1e230bbe4299bc4b7fe6e77eef88235f6d3fabde750067d55c9eadc02db"
    sha256 cellar: :any,                 arm64_linux:   "254efdbcfb120e8533e60be605b218423c98c6c2f103b2832c7439312b4841a8"
    sha256 cellar: :any,                 x86_64_linux:  "d640687addaf2313d870e85dd330f46bcdc8b117451326c89b50ac74c009b3f8"
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
