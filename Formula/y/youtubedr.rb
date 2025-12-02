class Youtubedr < Formula
  desc "Download Youtube Video in Golang"
  homepage "https://github.com/kkdai/youtube"
  url "https://github.com/kkdai/youtube/archive/refs/tags/v2.10.5.tar.gz"
  sha256 "69dff0cf97039f5364eeed070b3727332b1414b4e26f965bb505eae1fd291c25"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e87ab759d1215c50ae144a8aab75c4e2781a9cf7ac4e5d3e3a2923a01a331c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e87ab759d1215c50ae144a8aab75c4e2781a9cf7ac4e5d3e3a2923a01a331c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e87ab759d1215c50ae144a8aab75c4e2781a9cf7ac4e5d3e3a2923a01a331c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4896dac10773c7b78a959cf661f84a5b0cae7ebd5b95c7665780111330dea11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52642a705d28d7c58d676c6eb270dc76c2152b5c48f4bc9ee03e3c998488c6c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75074b9e7b3f2947fd535a1654a8f369ce4b7b1bb18fb5eec96e573d1edb8be2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/youtubedr"

    generate_completions_from_executable(bin/"youtubedr", "completion")
  end

  test do
    version_output = pipe_output("#{bin}/youtubedr version").split("\n")
    assert_match(/Version:\s+#{version}/, version_output[0])

    # Fails in Linux CI with "can't bypass age restriction: login required"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    info_output = pipe_output("#{bin}/youtubedr info https://www.youtube.com/watch?v=pOtd1cbOP7k").split("\n")
    assert_match "Title:       History of homebrew-core", info_output[0]
    assert_match "Author:      Rui Chen", info_output[1]
    assert_match "Duration:    13m15s", info_output[2]
  end
end
