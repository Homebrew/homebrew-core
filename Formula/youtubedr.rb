class Youtubedr < Formula
  desc "Download Youtube Video in Golang"
  homepage "https://github.com/kkdai/youtube"
  url "https://github.com/kkdai/youtube/archive/v2.2.1.tar.gz"
  sha256 "e0e298aa4d589813b635bc09e9b50b220f248312ec5893a381bacf70a624a9e1"
  license "MIT"

  bottle :unneeded

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
    output = pipe_output("#{bin}/youtubedr version")[0..17]
    assert_match(/Version:\s+#{Regexp.escape(version)}/, output)
  end
end
