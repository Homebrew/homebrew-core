class Vegeta < Formula
  desc "HTTP load testing tool and library"
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta.git",
      :tag      => "v12.7.0",
      :revision => "9c95632b3e8562be6df690c639a3f5a6f40d3004"

  bottle do
    cellar :any_skip_relocation
    sha256 "5b40fdc60f3bb98cb1c922ecbf84ea48748e97a3e31d979378f1abc2b6ea032a" => :mojave
    sha256 "d72fb9d6d2b987f0f35c0545d806a1ea4626e266641e6e8abecc4ce0be54e4ce" => :high_sierra
    sha256 "1596ae7a805382e2073fbc92a94c105d4176d75aace961e829c00dedd47b97b9" => :sierra
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
