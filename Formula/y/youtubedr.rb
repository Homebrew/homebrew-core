class Youtubedr < Formula
  desc "Download Youtube Video in Golang"
  homepage "https://github.com/kkdai/youtube"
  url "https://github.com/kkdai/youtube/archive/refs/tags/v2.8.3.tar.gz"
  sha256 "0b4cc6f45d8625412938a404053c408ee2371e6617c7ddb3a2468156df65c30d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ee4ca967d3f6760ee1ab128385e49ba6c3d9117662771f4a5d801bc5ec0be67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ee4ca967d3f6760ee1ab128385e49ba6c3d9117662771f4a5d801bc5ec0be67"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ee4ca967d3f6760ee1ab128385e49ba6c3d9117662771f4a5d801bc5ec0be67"
    sha256 cellar: :any_skip_relocation, ventura:        "2f0b6f02cf2cd7a2a39b56dae36f88e0b8b81823262bfe1e839554895ae8c17a"
    sha256 cellar: :any_skip_relocation, monterey:       "2f0b6f02cf2cd7a2a39b56dae36f88e0b8b81823262bfe1e839554895ae8c17a"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f0b6f02cf2cd7a2a39b56dae36f88e0b8b81823262bfe1e839554895ae8c17a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c462175778d4412dc3c51e0f92ce2c146f6d5a745a3c2d65f1f354c6ee32a2f3"
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

    generate_completions_from_executable(bin/"youtubedr", "completion")
  end

  test do
    version_output = pipe_output("#{bin}/youtubedr version").split("\n")
    assert_match(/Version:\s+#{version}/, version_output[0])

    info_output = pipe_output("#{bin}/youtubedr info https://www.youtube.com/watch?v=pOtd1cbOP7k").split("\n")
    assert_match "Title:       History of homebrew-core", info_output[0]
    assert_match "Author:      Rui Chen", info_output[1]
    assert_match "Duration:    13m15s", info_output[2]
  end
end
