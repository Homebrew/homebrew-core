require "language/go"

class Vegeta < Formula
  desc "HTTP load testing tool and library"
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta/archive/v6.1.0.tar.gz"
  sha256 "60d2b6cb51d069ef207f9c9e9a6c437df0f7159939ee10086131620f8e6d3916"

  bottle do
    cellar :any_skip_relocation
    sha256 "ad80d784b86ca30afa3ac8c0dd899d9166953be009ceb4cf784b07c64bf21701" => :el_capitan
    sha256 "9dea781e263dd683a17651fa3c18b91fed068510c189a0dbf0820d9eb04b9634" => :yosemite
    sha256 "b0ab8a3f5fe221bf139e45aa44cbf1d483c2a5b24590a9a3e0b1ca68eb735f4a" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/streadway/quantile" do
    url "https://github.com/streadway/quantile.git",
      :revision => "b0c588724d25ae13f5afb3d90efec0edc636432b"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
      :revision => "7864c9eef811cd4e2387a4d17eaf985e412b5032"
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
