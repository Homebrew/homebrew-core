class Youtubedr < Formula
  desc "Download Youtube Video in Golang"
  homepage "https://github.com/kkdai/youtube"
  url "https://github.com/kkdai/youtube/archive/refs/tags/v2.10.7.tar.gz"
  sha256 "5a030e0192b988e886c2be2c74e426963fd727ce0d2d26815d47eb40f9ff7f43"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a93213c7ef9a5be5a30e90094425325909dd78f120749057426dda4ddd784563"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a93213c7ef9a5be5a30e90094425325909dd78f120749057426dda4ddd784563"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a93213c7ef9a5be5a30e90094425325909dd78f120749057426dda4ddd784563"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "725d4c537634a584f3f724f0b6dceb93d1f7e7fd7f36aa7fe30de17322ac5a22"
    sha256 cellar: :any,                 x86_64_linux:      "87b06787fcbf1b1f7ab94ba4be809ca6b976e7d9bd871c8022114e48602f0e91"
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
