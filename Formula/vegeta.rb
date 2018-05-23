class Vegeta < Formula
  desc "HTTP load testing tool and library"
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta.git",
    :tag => "v7.0.1",
    :revision => "add59f4e5f067a0d6ceb53aefd57aaa3eee50e88"
  head "https://github.com/tsenart/vegeta.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "259302bc8757ce5260679fd5f88826c4e143a106fc27938a145ceb8a321d81bc" => :high_sierra
    sha256 "47522f5463ed21683a614b90478a2306b6d0ba2cef98d520a78645fa770ee9f3" => :sierra
    sha256 "2a49fd07e3b3171408ffd8ebbc82793b78217667e0daf63d43e4feaca3f9b279" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ENV["GOPATH"] = buildpath

    dir = buildpath / "src/github.com/tsenart/vegeta"
    dir.install buildpath.children
    cd dir do
      system "dep", "ensure"

      commit = Utils.popen_read("git rev-parse HEAD").chomp
      date = Time.now.strftime("%FT%T%:z") # e.g 2007-11-19T08:37:48-06:00
      system "go", "build", "-o", bin / "vegeta",
             "-a", '-tags="netgo"',
             "-ldflags", %Q(-s -w -extldflags "-static" -X main.Version=#{version} -X main.Commit=#{commit} -X main.Date=#{date})

      prefix.install_metafiles
    end
  end

  test do
    input = "GET https://google.com"
    output = pipe_output("#{bin}/vegeta attack -duration=1s -rate=1", input, 0)
    report = pipe_output("#{bin}/vegeta report", output, 0)
    assert_match(/Success +\[ratio\] +100.00%/, report)
  end
end
