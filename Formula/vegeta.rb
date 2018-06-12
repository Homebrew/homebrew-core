class Vegeta < Formula
  desc "HTTP load testing tool and library"
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta.git",
      :tag => "v8.0.0",
      :revision => "66f3db7f7dcc749f10144cbe4289f32adae346d3"

  bottle do
    cellar :any_skip_relocation
    sha256 "4577989ccecb06f40cbfbf6546328064bbcb946f9abe8c379d5028a29a72d5c5" => :high_sierra
    sha256 "dd9673cf1e9a6b6be20251d53d2707a1794a7b9653e0430ca38f438e238b9995" => :sierra
    sha256 "2ae78fd2f2703dec3ab2465cb58ef95a64780c97471fb30fc9de5d5c68481955" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/tsenart/vegeta").install buildpath.children
    cd "src/github.com/tsenart/vegeta" do
      system "make", "vegeta"
      bin.install "vegeta"
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
