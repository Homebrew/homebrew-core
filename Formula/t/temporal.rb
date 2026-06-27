class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/cli/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "09045e1b257c008c543cdb998eb05431a9b2ec9b233c5f0c3c6705bfc89a128d"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b25ffeb723acbae124ca045c21fa7cdff531ffe358a80b76d31364412849a0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe8e72756ed599fde27bdc7968f8797335e66bc5e04ba936528f31fc86ac6cd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14552b61380f72cf12ded5d7e01fdbab7ec2432455fbb213a4612138fcc70893"
    sha256 cellar: :any_skip_relocation, sonoma:        "f33bd6fb6ae88e1147c75a78e2d5f2630aecd87aaa1ce4ce080b337edbd6d2ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a51206a1001906b8afc0337b24d6d8bab484a98e01d3b839520a045419abfbb0"
    sha256 cellar: :any,                 x86_64_linux:  "2767916dd0431945b0ff5c4e7dce570287ce1baea3b75370148bed1512a6d861"
  end

  depends_on "go" => :build

  def install
    v = build.head? ? "0.0.0-HEAD+#{Utils.git_short_head}" : version.to_s
    ldflags = "-s -w -X github.com/temporalio/cli/internal/temporalcli.Version=#{v}"
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
    run_output = shell_output("#{bin}/temporal --version")
    assert_match "temporal version #{version}", run_output

    run_output = shell_output("#{bin}/temporal workflow list --address 192.0.2.0:1234 2>&1", 1)
    assert_match "failed reaching server", run_output
  end
end
