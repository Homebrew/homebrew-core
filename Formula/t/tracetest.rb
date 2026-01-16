class Tracetest < Formula
  desc "Build integration and end-to-end tests"
  homepage "https://docs.tracetest.io/"
  url "https://github.com/kubeshop/tracetest/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "9f2fb4edab3e469465302c70bcddf0f48517306db0004afdc1d016f30b5380e5"
  license "MIT" # MIT license for the CLI, TCL license for agent
  head "https://github.com/kubeshop/tracetest.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b58559ad7258bb4a1e2dc9903e0e242575e902f74f09c80113674c36d37de090"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b58559ad7258bb4a1e2dc9903e0e242575e902f74f09c80113674c36d37de090"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b58559ad7258bb4a1e2dc9903e0e242575e902f74f09c80113674c36d37de090"
    sha256 cellar: :any_skip_relocation, sonoma:        "24ca141eae8774c3027fa5fcd9adaa53da4583f50f70ef202690a78614192ba9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76ef355e9882480d77b0169167f8fa1987da394adfe293b3ebd19547883ee999"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92d2ceaeb6301b5cf9376ac4f915427c575dab211370621627234070f7b5127a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kubeshop/tracetest/cli/config.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cli"

    generate_completions_from_executable(bin/"tracetest", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tracetest version 2>&1", 1)

    assert_match "Server: Not Configured", shell_output("#{bin}/tracetest list 2>&1", 1)
  end
end
