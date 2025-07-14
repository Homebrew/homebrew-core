class Youtubedr < Formula
  desc "Download Youtube Video in Golang"
  homepage "https://github.com/kkdai/youtube"
  url "https://github.com/kkdai/youtube/archive/refs/tags/v2.10.4.tar.gz"
  sha256 "c1c282ae902d84f65ea3e891bb8da48525b5d9b0cc9662c277312d5cc402ea66"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "908db821e0a543801517fa6195aabf2ae9a688ed7037e89d629f5723b509f141"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "908db821e0a543801517fa6195aabf2ae9a688ed7037e89d629f5723b509f141"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "908db821e0a543801517fa6195aabf2ae9a688ed7037e89d629f5723b509f141"
    sha256 cellar: :any_skip_relocation, sonoma:        "812303cccd71ab7bd988ee97428eab75afa80d562f939f5021491609d27333fd"
    sha256 cellar: :any_skip_relocation, ventura:       "812303cccd71ab7bd988ee97428eab75afa80d562f939f5021491609d27333fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfd738a7fb08baf4d5c4f6bd2c561ce742c4f99288f6dd1c078565aae27591e0"
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
