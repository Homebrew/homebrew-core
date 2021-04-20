class Youtubedr < Formula
  desc "Download Youtube Video in Golang"
  homepage "https://github.com/kkdai/youtube"
  url "https://github.com/kkdai/youtube/archive/v2.6.1.tar.gz"
  sha256 "8f42e8807dd37bbb2d3ebb053bda81cdcaf8fab0ba5d75ea8ca2007f5f4d1e58"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6c5f7e9e889d455f28a45e5a31bc36ab475684faa420ea4e48ace94ce81bfb27"
    sha256 cellar: :any_skip_relocation, big_sur:       "dbb29d33a0151f7662a74ae496aa033d282369276fbcd20e51600c7611337dc7"
    sha256 cellar: :any_skip_relocation, catalina:      "b95254549a0ab2002da5c2577e2e4fbea2bce4bae6e0c0a9fefaf2cb871d456e"
    sha256 cellar: :any_skip_relocation, mojave:        "16cf7532f5ae3877dbcfa833309138b0e86985b856187e1ea8fddea9ba164b86"
  end

  depends_on "go" => :build

  def install
    build_time = Time.now.utc.strftime("%Y-%m-%dT%H:%M:%SZ")

    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{build_time}
    ]

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", "-ldflags", ldflags.join(" "), *std_go_args, "./cmd/youtubedr"
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
