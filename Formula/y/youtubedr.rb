class Youtubedr < Formula
  desc "Download Youtube Video in Golang"
  homepage "https://github.com/kkdai/youtube"
  url "https://github.com/kkdai/youtube/archive/refs/tags/v2.10.3.tar.gz"
  sha256 "697ca27f894efdd3f1249b46d7e587a3d1348158e130c5c1307ce32d505c6d01"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80be28d8e4ae7338c0265cd4c41f23c932fc38dc5547079b261d5dc4a2b22252"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80be28d8e4ae7338c0265cd4c41f23c932fc38dc5547079b261d5dc4a2b22252"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "80be28d8e4ae7338c0265cd4c41f23c932fc38dc5547079b261d5dc4a2b22252"
    sha256 cellar: :any_skip_relocation, sonoma:        "c50f57c5f6eabfb52a640149f3c1a9941c7fbdbaf97349d31ada9f4cfe14cb1c"
    sha256 cellar: :any_skip_relocation, ventura:       "c50f57c5f6eabfb52a640149f3c1a9941c7fbdbaf97349d31ada9f4cfe14cb1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7812640bda54733cb1ee2b0144041576815809a3c6381ea75b082db2dc39a7b1"
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
