class Vegeta < Formula
  desc "HTTP load testing tool and library"
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta.git",
      :tag      => "cli/v12.4.0",
      :revision => "e827e02858e8d5d581bac4d57b31fbd275da39c5"

  bottle do
    cellar :any_skip_relocation
    sha256 "26cb57424a617a578f0e9d3e3c73df7cfdf949799ec2e55f44c7870ffd99a2ed" => :mojave
    sha256 "1999cb820385c33d3b7d24c68e37443302014f9ee1538c2c2a40fb9db555b4c1" => :high_sierra
    sha256 "b25663189727f425586cd5c97abba8dfd64ea6556f991dacd452654d1b82779b" => :sierra
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
