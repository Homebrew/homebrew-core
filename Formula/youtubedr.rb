class Youtubedr < Formula
  desc "Download Youtube Video in Golang"
  homepage "https://github.com/kkdai/youtube"
  url "https://github.com/kkdai/youtube/archive/v2.7.4.tar.gz"
  sha256 "991b15a0b6941c1bf2c3d691b8b5f2f37b28a041e735813da051cb5a01e38695"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fcdf0f3023fb40d45b9401522ad668a97a39a1d580b826a5989ab8028708274"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ee6ab25e29be16fb8a7e96032ebd1e91848368fdf75504e5ff7e4409db1732d"
    sha256 cellar: :any_skip_relocation, monterey:       "91b490522cae89c80a15da46cc1a8f729e37b46aca1f6294f5a955b92ebdf145"
    sha256 cellar: :any_skip_relocation, big_sur:        "80d0c11df93af2a56e092d2aaa7012ae61c781045ceddffe4cdc9872e9efe2f0"
    sha256 cellar: :any_skip_relocation, catalina:       "80d0c11df93af2a56e092d2aaa7012ae61c781045ceddffe4cdc9872e9efe2f0"
    sha256 cellar: :any_skip_relocation, mojave:         "80d0c11df93af2a56e092d2aaa7012ae61c781045ceddffe4cdc9872e9efe2f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48ee061f5c900b2c775d4ab135f2feffefd1799d094bb4d5e8482e91329b7e6a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ].join(" ")

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/youtubedr"
  end

  test do
    version_output = pipe_output("#{bin}/youtubedr version").split("\n")
    assert_match(/Version:\s+#{version}/, version_output[0])

    info_output = pipe_output("#{bin}/youtubedr info https://www.youtube.com/watch\?v\=pOtd1cbOP7k").split("\n")
    assert_match "Title:       History of homebrew-core", info_output[0]
    assert_match "Author:      Rui Chen", info_output[1]
    assert_match "Duration:    13m15s", info_output[2]
  end
end
