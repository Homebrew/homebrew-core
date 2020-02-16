class Vegeta < Formula
  desc "HTTP load testing tool and library"
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta.git",
      :tag      => "v12.8.0",
      :revision => "7232e921ca2001e87fb39c3df6934e951faf59fa"

  bottle do
    cellar :any_skip_relocation
    sha256 "8bcc25e5a17aabc111d71ea916e8433589a9fe9e41bf5f172c77faafdd4285c5" => :catalina
    sha256 "5b40fdc60f3bb98cb1c922ecbf84ea48748e97a3e31d979378f1abc2b6ea032a" => :mojave
    sha256 "d72fb9d6d2b987f0f35c0545d806a1ea4626e266641e6e8abecc4ce0be54e4ce" => :high_sierra
    sha256 "1596ae7a805382e2073fbc92a94c105d4176d75aace961e829c00dedd47b97b9" => :sierra
  end

  depends_on "go" => :build

  def install
    commit = Utils.popen_read("git rev-parse --short HEAD").chomp
    build_time = Utils.popen_read("date -u +'%Y-%m-%dT%H:%M:%SZ' 2> /dev/null").chomp

    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Commit=#{commit}
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
