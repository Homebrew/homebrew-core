class Vegeta < Formula
  desc "HTTP load testing tool and library"
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta/archive/v12.8.3.tar.gz"
  sha256 "2e6326b2fe0ef273ae784600e2181e32d307b62beb29cc84ffc8ddd0d5352df9"

  bottle do
    cellar :any_skip_relocation
    sha256 "11fc785f649354761d2d4060f311e29ab5dcc7217b3fe6c1dc0c0b932dc6ea60" => :catalina
    sha256 "ebcff7033c06c152bdf9b2e58d71e67450aed726130d05e37e2f74462b2e3538" => :mojave
    sha256 "cd5cedfa3aebbabadbaaebdf2963fd97df4073fb6033ddcd284691e9e1d4ae35" => :high_sierra
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
