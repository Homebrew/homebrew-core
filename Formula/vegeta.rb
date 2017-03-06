require "language/go"

class Vegeta < Formula
  desc "HTTP load testing tool and library"
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta/archive/v6.2.0.tar.gz"
  sha256 "f58d8cf885b4d230612f4b5d458fc1ec1b6dac6bc6c1d088ec081a03234a6cae"

  bottle do
    cellar :any_skip_relocation
    sha256 "d7aa6533148d3cf25e5d6bc731ace3af481b7258e3335c0256293b6da4ac9100" => :sierra
    sha256 "c1d8e0a8fd18c9e02dc84a016016d37a6668aa70081ae861a734781b9c22884f" => :el_capitan
    sha256 "7028d0d721260655ae42cacf7f63f38373ada4053120d46178bb7ad9657f877e" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/streadway/quantile" do
    url "https://github.com/streadway/quantile.git",
        :revision => "b0c588724d25ae13f5afb3d90efec0edc636432b"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "6250b412798208e6c90b03b7c4f226de5aa299e2"
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
