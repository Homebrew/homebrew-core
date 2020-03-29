class Vegeta < Formula
  desc "HTTP load testing tool and library"
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta/archive/v12.8.3.tar.gz"
  sha256 "2e6326b2fe0ef273ae784600e2181e32d307b62beb29cc84ffc8ddd0d5352df9"

  bottle do
    cellar :any_skip_relocation
    sha256 "f93a70561ffc7d97fb58638e1555148058036f1b65ee3b0891352346a256c8d5" => :catalina
    sha256 "f3496b02858387a32051d015677ca417c04251b2a98b6d36d8611836908dd23e" => :mojave
    sha256 "d03417e5f8bf936b8fa726f6ec25607809db1e284a4ca98ebf884fea3825ec49" => :high_sierra
  end

  depends_on "go" => :build

  def install
    build_time = Utils.popen_read("date -u +'%Y-%m-%dT%H:%M:%SZ' 2> /dev/null").chomp

    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Date=#{build_time}
    ]

    system "go", "build", "-o", bin/"vegeta", "-ldflags", ldflags.join(" ")
  end

  test do
    input = "GET https://google.com"
    output = pipe_output("#{bin}/vegeta attack -duration=1s -rate=1", input, 0)
    report = pipe_output("#{bin}/vegeta report", output, 0)
    assert_match(/Success +\[ratio\] +100.00%/, report)
  end
end
