class Youtubedr < Formula
  desc "Download Youtube Video in Golang"
  homepage "https://github.com/kkdai/youtube"
  url "https://github.com/kkdai/youtube/archive/refs/tags/v2.10.5.tar.gz"
  sha256 "69dff0cf97039f5364eeed070b3727332b1414b4e26f965bb505eae1fd291c25"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b7981af15f827a881e2aa7fceab42b16e005910d4ff2d46d6db633a7d575264"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b7981af15f827a881e2aa7fceab42b16e005910d4ff2d46d6db633a7d575264"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b7981af15f827a881e2aa7fceab42b16e005910d4ff2d46d6db633a7d575264"
    sha256 cellar: :any_skip_relocation, sonoma:        "05c20777846400eca21ac26fdfdada02d52204ed8afb125ba38b3390a572e21e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "710706ec6dbf8eed88a69bbf9e612d4091d68b56ba681a158693a5da12d78464"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40235abb2ff3934b3dbc9ac18320034def5efd627ac026bf224b93f0d0f83b1e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/youtubedr"

    generate_completions_from_executable(bin/"youtubedr", shell_parameter_format: :cobra)
  end

  test do
    version_output = pipe_output("#{bin}/youtubedr version").split("\n")
    assert_match(/Version:\s+#{version}/, version_output[0])

    output = pipe_output("#{bin}/youtubedr info https://www.youtube.com/watch?v=pOtd1cbOP7k 2>&1")
    if $CHILD_STATUS.exitstatus.nonzero? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      # CI runners can be blocked by YouTube, https://github.com/kkdai/youtube/issues/336
      assert_match "can't bypass age restriction:", output
    else
      info_output = output.split("\n")
      assert_match "Title:       History of homebrew-core", info_output[0]
      assert_match "Author:      Rui Chen", info_output[1]
      assert_match "Duration:    13m15s", info_output[2]
    end
  end
end
