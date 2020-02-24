class Vegeta < Formula
  desc "HTTP load testing tool and library"
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta.git",
      :tag      => "v12.8.0",
      :revision => "7232e921ca2001e87fb39c3df6934e951faf59fa"

  bottle do
    cellar :any_skip_relocation
    sha256 "acf72b24bc38f36b494f348f519a9228f4c793d00af85760f3d28e67e1df6e67" => :catalina
    sha256 "3ef18ccbcc6f813a9dcbc2ee34c0d04834719ee16e831135d0b0209146fa1bae" => :mojave
    sha256 "75f3d6310b983c6529b7d80820c798a17214216af47be19a65e1753b5044f54c" => :high_sierra
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
