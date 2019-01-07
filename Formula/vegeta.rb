class Vegeta < Formula
  desc "HTTP load testing tool and library"
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta.git",
      :tag      => "cli/v12.2.0",
      :revision => "65db074680f5a0860d495e5fd037074296a4c425"

  bottle do
    cellar :any_skip_relocation
    sha256 "4bbc3b02ddf47cb7d75c4344744ec9c273145174d5ead4b9141a7d4f4418aa1f" => :mojave
    sha256 "f3fdd71e68611f4227b7b12eb3e0ab6499a2166c5f096aeeb1819d052aacf81a" => :high_sierra
    sha256 "0a5a909e5c563ca6ae28cb96f11a95e1dca2eb036824d7152b6eb5f504155da1" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    src = buildpath/"src/github.com/tsenart/vegeta"
    src.install buildpath.children
    src.cd do
      system "make", "vegeta"
      bin.install "vegeta"
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
