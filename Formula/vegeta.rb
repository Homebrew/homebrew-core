require "language/go"

class Vegeta < Formula
  desc "HTTP load testing tool and library"
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta/archive/v6.3.0.tar.gz"
  sha256 "b9eaf9dc748fa58360395641ff50a33e53c805bf8a45ba3d787133d97b2269c6"

  bottle do
    cellar :any_skip_relocation
    sha256 "47e1b8f045671f42701a959baac1d37e967b6be0196dff6b8c088df5763a2a5f" => :sierra
    sha256 "aadfb9ec8717221b59cad02eb1eec3464e75e8c05ff3f695f07291b8a9b87fdb" => :el_capitan
    sha256 "4e449d903b750dbbe063b024cd06ba82edb1490db4774fdda9c4e228df8256be" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/streadway/quantile" do
    url "https://github.com/streadway/quantile.git",
        :revision => "b0c588724d25ae13f5afb3d90efec0edc636432b"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "a6577fac2d73be281a500b310739095313165611"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["CGO_ENABLED"] = "0"

    (buildpath/"src/github.com/tsenart").mkpath
    ln_s buildpath, buildpath/"src/github.com/tsenart/vegeta"
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-ldflags", "-X main.Version=#{version}",
                          "-o", bin/"vegeta"
  end

  test do
    input = "GET https://google.com"
    output = pipe_output("#{bin}/vegeta attack -duration=1s -rate=1", input, 0)
    report = pipe_output("#{bin}/vegeta report", output, 0)
    assert_match /Success +\[ratio\] +100.00%/, report
  end
end
