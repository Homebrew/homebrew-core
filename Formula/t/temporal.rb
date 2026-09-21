class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/cli/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "d0310b8f4ef26b8a2240aa2e783c67c099406be01f34cf4edb3ae8aa2d86b7bb"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a8458821c49b8c5d50a4b9f2d5d2c587ae7a1da5a5e04da59410146fc8b6311e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1b1059bdcf06a2eb6bc835d70d583b3454c80d4cbf2781ee9e3fd97a6639a4b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2825ad96b8aead509e4b3bdd347de25ec90965f9e584581dbdd9ccb3acf87d24"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "53023811e0a158eaf7b55d4197c7c969f9a7d9920c5dc132aa86dc883779bee5"
    sha256 cellar: :any,                 x86_64_linux:      "6a4430177c0accca5f76215f8a7377571ec9ced4193542cce13a2873f3106850"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    v = build.head? ? "0.0.0-HEAD+#{Utils.git_short_head}" : version.to_s
    ldflags = "-X github.com/temporalio/cli/internal/temporalcli.Version=#{v}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/temporal"

    generate_completions_from_executable(bin/"temporal", shell_parameter_format: :cobra)
  end

  service do
    run [opt_bin/"temporal", "server", "start-dev"]
    keep_alive true
    error_log_path var/"log/temporal.log"
    log_path var/"log/temporal.log"
    working_dir var
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/temporal --version")

    assert_match "failed connecting to Temporal server",
      shell_output("#{bin}/temporal workflow list --address 192.0.2.0:1234 2>&1", 1)
  end
end
