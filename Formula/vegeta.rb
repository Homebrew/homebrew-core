class Vegeta < Formula
  desc "HTTP load testing tool and library"
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta.git",
      :tag => "v8.0.0",
      :revision => "66f3db7f7dcc749f10144cbe4289f32adae346d3"

  bottle do
    cellar :any_skip_relocation
    sha256 "da42d92e8396f4041bbefd36c654285c66dd8cf5c84872e8dcdb55a623480e70" => :high_sierra
    sha256 "ddd82b9d40026254d4e64fa5b73d82e4ce7b0d6ff559381a72c541fc5935dbac" => :sierra
    sha256 "e5c6176bb601d861ba50d89a50ae19a0a6998a5b06b6f8b9e87c72ade4e25c23" => :el_capitan
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
