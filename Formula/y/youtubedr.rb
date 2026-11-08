class Youtubedr < Formula
  desc "Download Youtube Video in Golang"
  homepage "https://github.com/kkdai/youtube"
  url "https://github.com/kkdai/youtube/archive/refs/tags/v2.10.8.tar.gz"
  sha256 "14ea78ee215a017e8cffa85b3de34f69063c9619ae13eb0154229a67362b03ab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b8d7caed31508e087e9fa2cab2a92bee662d05c173667a6c4240dc9f80a5aa31"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b8d7caed31508e087e9fa2cab2a92bee662d05c173667a6c4240dc9f80a5aa31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b8d7caed31508e087e9fa2cab2a92bee662d05c173667a6c4240dc9f80a5aa31"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2fe82860956884e36c7a468b194b196a1265b4189295108e5416a40056f79342"
    sha256 cellar: :any,                 x86_64_linux:      "e9c476e55e3ca5623d00395b23bafa16c21b9663fd43e46d6708bfc22ba12c39"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/youtubedr"

    generate_completions_from_executable(bin/"youtubedr", shell_parameter_format: :cobra)
  end

  test do
    version_output = pipe_output("#{bin}/youtubedr version").split("\n")
    assert_match(/Version:\s+#{version}/, version_output[0])

    output = pipe_output("#{bin}/youtubedr info https://www.youtube.com/watch?v=pOtd1cbOP7k 2>&1")
    if $CHILD_STATUS.exitstatus.nonzero? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      # CI runners can be blocked by YouTube, https://github.com/kkdai/youtube/issues/336
      assert_match "youtube requires a sign-in to confirm you're not a bot", output
    else
      info_output = output.split("\n")
      assert_match "Title:       History of homebrew-core", info_output[0]
      assert_match "Author:      Rui Chen", info_output[1]
      assert_match "Duration:    13m15s", info_output[2]
    end
  end
end
