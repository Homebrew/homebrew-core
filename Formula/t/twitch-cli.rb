class TwitchCli < Formula
  desc "CLI to make developing on Twitch easier"
  homepage "https://github.com/twitchdev/twitch-cli"
  url "https://github.com/twitchdev/twitch-cli/archive/refs/tags/v1.1.25.tar.gz"
  sha256 "63d13cd54b64e17237650d7aaadb1453fe28565f54111be056beb24d58831c67"
  license "Apache-2.0"
  head "https://github.com/twitchdev/twitch-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "138964474a40f751a228aaf34807b3040c906fa223af73c80bf948a1f41fc4d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46c2326b2b21618cdbc86c7469e863301a71a1e9ab5b5f3313c5e204cb62e099"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd89ac2c534af562c2213b52eaa12a181c145d099d86f45ef80e5af0926a8ed3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f9c5a15fb1412f96d2db036f72bf1c72dc36643d8f067ff6ed7937d132f7153"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c4a06fb87e8f90426d94117dddd7ccfba176b57084331c9e9b04ca473e71271"
    sha256 cellar: :any_skip_relocation, ventura:       "d6d991cb51f10126ceb455fc579dc97ec278cd14b007d3267670ff09b536d436"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d934024bce9a3de783dce2c8929ac17f822ac8632d4b786da4c5953713ade24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe71e31769022181108b966e4adadaab884c53a3ebdb754b70be5cd613475c23"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.buildVersion=#{version}", output: bin/"twitch")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/twitch version")
    output = shell_output("#{bin}/twitch mock-api generate 2>&1")
    assert_match "Name: Mock API Client", output
  end
end
