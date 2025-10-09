class Tracetest < Formula
  desc "Build integration and end-to-end tests"
  homepage "https://docs.tracetest.io/"
  url "https://github.com/kubeshop/tracetest/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "9f2fb4edab3e469465302c70bcddf0f48517306db0004afdc1d016f30b5380e5"
  license "MIT" # MIT license for the CLI, TCL license for agent
  head "https://github.com/kubeshop/tracetest.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4e174c5e1728e5f76c7474244d22351c5c0ec14d02d3f9e0fa9cf0471fd798a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4e174c5e1728e5f76c7474244d22351c5c0ec14d02d3f9e0fa9cf0471fd798a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4e174c5e1728e5f76c7474244d22351c5c0ec14d02d3f9e0fa9cf0471fd798a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6b1da02531d87d79eac9d39dfb0ca789d31dfb1f4ee9711b2f65a6031609240"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00de76769264422d7739b45c3bfcafcf599a347ef4e2dbb666ad39951874e33a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b93cbf60776d43d78f16f9f6235519ff7c1a3c4546770b680fd44e443f4df7a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kubeshop/tracetest/cli/config.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cli"

    generate_completions_from_executable(bin/"tracetest", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tracetest version 2>&1", 1)

    assert_match "Server: Not Configured", shell_output("#{bin}/tracetest list 2>&1", 1)
  end
end
