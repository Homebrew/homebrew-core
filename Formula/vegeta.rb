class Vegeta < Formula
  desc "HTTP load testing tool and library"
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta/archive/v7.0.0.tar.gz"
  sha256 "b9e2ae43b832849c46e9aa0e1cddf5938e79b9addad01481b3cbfb7aa09a03cb"

  bottle do
    cellar :any_skip_relocation
    sha256 "259302bc8757ce5260679fd5f88826c4e143a106fc27938a145ceb8a321d81bc" => :high_sierra
    sha256 "47522f5463ed21683a614b90478a2306b6d0ba2cef98d520a78645fa770ee9f3" => :sierra
    sha256 "2a49fd07e3b3171408ffd8ebbc82793b78217667e0daf63d43e4feaca3f9b279" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["CGO_ENABLED"] = "0"

    (buildpath/"src/github.com/tsenart/vegeta").install buildpath.children
    cd "src/github.com/tsenart/vegeta" do
      system "dep", "ensure"
      system "go", "build", "-ldflags", "-X main.Version=#{version}",
                            "-o", bin/"vegeta"
      prefix.install_metafiles
    end
  end

  test do
    input = "GET https://google.com"
    output = pipe_output("#{bin}/vegeta attack -duration=1s -rate=1", input, 0)
    report = pipe_output("#{bin}/vegeta report", output, 0)
    assert_match /Success +\[ratio\] +100.00%/, report
  end
end
