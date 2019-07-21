class Vegeta < Formula
  desc "HTTP load testing tool and library"
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta.git",
      :tag      => "v12.7.0",
      :revision => "9c95632b3e8562be6df690c639a3f5a6f40d3004"

  bottle do
    cellar :any_skip_relocation
    sha256 "33d9036b2796f539b00eaf981199f6505b08e9f501cadd526560fe4a3fda20d6" => :mojave
    sha256 "904605be1cb8ccf12e9cc80ff153750721c75721973130563d64ab1790c831e2" => :high_sierra
    sha256 "cacd78a85de4256bc83f476bf93fdbaa3ff80a788d65923a743cce54a927c3c1" => :sierra
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
