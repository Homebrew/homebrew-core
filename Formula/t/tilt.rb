class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
      tag:      "v0.37.9",
      revision: "800e855f43393d0a19e654f3a2eeae127c050fe1"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8338b34e637cf7fc31cd77fdbd137355858bb4cab6609321ef7b2401e79c0cd5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a0579763d3c7469bbb83988c5960e3f7264c677fabd4091b793696f4dbeee3c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "685a528600fe6dea18566d4eb21035f052dbb8d528517f38230d7bbbc66288cd"
    sha256 cellar: :any,                 arm64_linux:       "e2f6f52109402c55e073578f8a175786676d58b92f8d4491530739b118ae2729"
    sha256 cellar: :any,                 x86_64_linux:      "08d5a200e1fd23ad7fe6ae932aad569ad2c1af446968aa1902a43582d2d2e678"
  end

  depends_on "corepack" => :build # for newer yarn
  depends_on "go" => :build
  depends_on "node" => :build

  deny_network_access!

  def fetch
    ENV["COREPACK_ENABLE_DOWNLOAD_PROMPT"] = "0"

    # Go dependencies are vendored, so only the frontend assets need
    # downloading; bundling them downloads yarn and npm packages.
    system "make", "build-js"
  end

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = %W[
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
