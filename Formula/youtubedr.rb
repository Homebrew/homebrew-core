class Youtubedr < Formula
  desc "Download Youtube Video in Golang"
  homepage "https://github.com/kkdai/youtube"
  url "https://github.com/kkdai/youtube/archive/v2.3.0.tar.gz"
  sha256 "359c271b641675e20842e5e5146708b477869e55988927dd9610c2a03311f55f"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "a82e3c0afb87bc378fa7619c2afc65ace75c234c4713b50badd97f2db34af5a9" => :big_sur
    sha256 "2767bd8bd91ac47287b7a16902fd457dfaa20ced285d2f85ab4f8c8dd384e290" => :catalina
    sha256 "3fcd3f4118d41a2aee8ebdde0d4437bfb32a641af1a13233070f126acc387477" => :mojave
  end

  depends_on "go" => :build

  def install
    build_time = Utils.safe_popen_read("date -u +'%Y-%m-%dT%H:%M:%SZ' 2> /dev/null").chomp

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
