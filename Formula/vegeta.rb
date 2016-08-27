require "language/go"

class Vegeta < Formula
  desc "HTTP load testing tool and library"
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta/archive/v6.1.1.tar.gz"
  sha256 "57bdab4cebcd1ee512c4dd4b0347e8058029e6f852a494ec1a18a9c3120bc30c"

  bottle do
    cellar :any_skip_relocation
    sha256 "c0d6e23a90813fa070cb94d9575a31a30521a775bdc79f6845e31108a5ea4c2f" => :el_capitan
    sha256 "dbfff75fd771d7069bfcfb0b32d7ca0c10e418274579ef8c44a3dd95a67598cb" => :yosemite
    sha256 "fc92ba69046139fc5c5f281beb517dafafc78148c47005d72637b1c51b62c8e3" => :mavericks
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
