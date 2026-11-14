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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "54725585f4e061375642ecc26943d8a08ab45b401201e1e584bf963530e44162"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "06430c323b1c2ce3b9c0402433e9295375c50053669048bc2a5d16f17176c7d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5caf559f31e6cdb259713dfdbabadc7b8f3508b9d86e6d677ec843c38815c7ff"
    sha256 cellar: :any,                 arm64_linux:       "466e7ad219da312e8018fc6f2c9cf72f72419d3b996e1643da8aae94ca72301d"
    sha256 cellar: :any,                 x86_64_linux:      "528adb23b4e06ca455403b4161b925ddf03d051738c50c6dd101f016b8b3aadc"
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
