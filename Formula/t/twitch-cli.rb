class TwitchCli < Formula
  desc "CLI to make developing on Twitch easier"
  homepage "https://github.com/twitchdev/twitch-cli"
  url "https://github.com/twitchdev/twitch-cli/archive/refs/tags/v1.1.25.tar.gz"
  sha256 "63d13cd54b64e17237650d7aaadb1453fe28565f54111be056beb24d58831c67"
  license "Apache-2.0"
  head "https://github.com/twitchdev/twitch-cli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10450a73259cfeb284d60cb524a173937a614973f7317663fb600062981db89a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56204390fab301db7683d5189880567af4b6daa19722ae071055dfc2efded16d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "875005fb73ea06710dcb3e18ce78e1f893f8b7831468ec7c7f7e7bb13b9091ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "cff4c98ba9d9ce9c64ae96d3d342c54702137ffcae207b9614fbd518cb7a138e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45680e27634d86f2cd668a66e1521383aee6fc8dbfa771ee6387bd7baf18d32b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7051314655660caeb40a7edfd372aa812c3599067861fef27cb5d0c52a8315d"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-s -w -X main.buildVersion=#{version}", output: bin/"twitch")

    generate_completions_from_executable(bin/"twitch", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/twitch version")
    output = shell_output("#{bin}/twitch mock-api generate 2>&1")
    assert_match "Name: Mock API Client", output
  end
end
