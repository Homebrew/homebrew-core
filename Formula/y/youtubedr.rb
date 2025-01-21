class Youtubedr < Formula
  desc "Download Youtube Video in Golang"
  homepage "https://github.com/kkdai/youtube"
  url "https://github.com/kkdai/youtube/archive/refs/tags/v2.10.2.tar.gz"
  sha256 "7c8f8875fbf47110782e4ebd24dd70e3bb277cf25a7802d89fe4ca00d684e1d1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0715f7a73fc51198b85a9e07f3f04112608742f2deb8100d776174257a91528b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0715f7a73fc51198b85a9e07f3f04112608742f2deb8100d776174257a91528b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0715f7a73fc51198b85a9e07f3f04112608742f2deb8100d776174257a91528b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff185b46ae18551197253d6048642a263abb84934c6f3e2ce946f553905d5f0c"
    sha256 cellar: :any_skip_relocation, ventura:       "ff185b46ae18551197253d6048642a263abb84934c6f3e2ce946f553905d5f0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8541d6b07a6e62ad4af72d8dfe1b936937ae49597014824e7c3dc7cd10e675d6"
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
