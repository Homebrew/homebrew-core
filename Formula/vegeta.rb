class Vegeta < Formula
  desc "HTTP load testing tool and library"
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta.git",
      :tag      => "cli/v12.1.0",
      :revision => "c120b942b43950d4237e41f31152706fbc3d4c0d"

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
    (buildpath/"src/github.com/tsenart/vegeta").install buildpath.children
    ENV.prepend_create_path "PATH", buildpath/"bin"
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
