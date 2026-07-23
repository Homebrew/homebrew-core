class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/cli/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "bea6deb72665178900c1bab95d498c6a2f24dabf1f7033b580413354222266bc"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c167d0d2b4450220441717153c45715ac56b547e663c4e397df96cd08073cc55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9de2164eb5e3d1ea602df93f0ba6a9792deb061a0293e8e5c93e9d5d536f990b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf38ba537fa60e2970dd802d16af75e1ca0aae84067b453261a9f91452a13e9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "4094f9d04776a481548da410ad11898798e699edb111a84aaa8dad88d31d8371"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07fc43f3fa6e4381795fae8b3d2e5fe51142d3c1f9292bb168fcdbd28ac3e412"
    sha256 cellar: :any,                 x86_64_linux:  "29336013e3fcc4c9f427e04588f6dc46a7cb52d5e1ae46f31e1af9f049ea9b91"
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
