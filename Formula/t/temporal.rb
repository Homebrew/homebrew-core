class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/cli/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "7f0e9ac007df107f6efc05e8ac257642956ec0e04d565bf800ccc3ce62cf70dd"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82c0f26acd6a4c6385fa3549d872f61a956401ccc7ddaa939dcc9e4f665669cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2adb78c9fea26d55e865e8004a2765fd4526b442f76f9d6489ebbd405e9dac21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d9175db0088a135048c8cc63517f8af8cf50cd59a2cf8b955b56d59d1cdfb73"
    sha256 cellar: :any_skip_relocation, sonoma:        "03587c99c54be762b89e4e9bb0db4a16536fb4126cb1baa34cdc1c79fd526189"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43eb2efae26665e68b1c7dfc266ed7734fe42ca68b8cf47c3b721815e462401a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d9933fe62ca6bd26fdf1a136fd30a2bcd0620ce582869a5e5475158a22c3c3d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/temporalio/cli/temporalcli.Version=#{version}"
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
