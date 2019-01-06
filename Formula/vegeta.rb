class Vegeta < Formula
  desc "HTTP load testing tool and library"
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta.git",
      :tag      => "cli/v12.2.0",
      :revision => "65db074680f5a0860d495e5fd037074296a4c425"

  bottle do
    cellar :any_skip_relocation
    sha256 "506681f1819a6b2b0213caa417d5d53a7bf00944053fa882dc076028013fbc6d" => :mojave
    sha256 "d97eba9cd27f5713cd5007506a3377519d91d1c770072e69e8dbf5e91ccdbbc0" => :high_sierra
    sha256 "1d67d0b99408572a976af51ddb4194408452eca2e094aa22ea1de80e89a964c8" => :sierra
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
