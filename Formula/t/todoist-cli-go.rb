class TodoistCliGo < Formula
  desc "CLI for Todoist"
  homepage "https://github.com/sachaos/todoist"
  url "https://github.com/sachaos/todoist/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "1993d51b1d6fe85c521bc215584674631bef59fe1e9a4e29cf19d921e8df303f"
  license "MIT"
  head "https://github.com/sachaos/todoist.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "705fc9c1566919b2194cd3181d28bbd54b8e2adc244007ed6817df8990fdfcda"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "705fc9c1566919b2194cd3181d28bbd54b8e2adc244007ed6817df8990fdfcda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "705fc9c1566919b2194cd3181d28bbd54b8e2adc244007ed6817df8990fdfcda"
    sha256 cellar: :any_skip_relocation, sonoma:        "01abdd671c2f6e2419edc45945480b49e8ee2f6f6be4b7b88b8acecd275dd844"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "061e8e55f6db1d06adbf2aebd788bdcd783d0b835a9257db6a9595dc1bf0c27b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a90b3ad25e91084e4630a2d801670cc6b361f04b81ac30f74695072b165f5b2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(output: bin/"todoist", ldflags:)
  end

  def caveats
    <<~EOS
      This formula was renamed from "todoist-cli" to "todoist-cli-go" to
      free up the "todoist-cli" name for the official Doist CLI
      (https://github.com/Doist/todoist-cli).
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/todoist --version")

    test_config = testpath/".config/todoist/config.json"
    test_config.write <<~JSON
      {
        "token": "test_token"
      }
    JSON
    chmod 0600, test_config

    output = shell_output("#{bin}/todoist list 2>&1")
    assert_match "There is no task.", output
  end
end
