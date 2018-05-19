class Vegeta < Formula
  desc "HTTP load testing tool and library"
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta/archive/v7.0.0.tar.gz"
  sha256 "b9e2ae43b832849c46e9aa0e1cddf5938e79b9addad01481b3cbfb7aa09a03cb"

  bottle do
    cellar :any_skip_relocation
    sha256 "db26954bbe7b4daa945ca7dbed49d629579416da33fe16333fd36a6e11bbce0d" => :high_sierra
    sha256 "47e1b8f045671f42701a959baac1d37e967b6be0196dff6b8c088df5763a2a5f" => :sierra
    sha256 "aadfb9ec8717221b59cad02eb1eec3464e75e8c05ff3f695f07291b8a9b87fdb" => :el_capitan
    sha256 "4e449d903b750dbbe063b024cd06ba82edb1490db4774fdda9c4e228df8256be" => :yosemite
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
