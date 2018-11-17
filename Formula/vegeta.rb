class Vegeta < Formula
  desc "HTTP load testing tool and library"
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta.git",
      :tag      => "cli/v12.1.0",
      :revision => "c120b942b43950d4237e41f31152706fbc3d4c0d"

  bottle do
    cellar :any_skip_relocation
    sha256 "976a519bfe629504379b47e479b117d79fb87daaaa5bd6139a3695948cc7fff8" => :mojave
    sha256 "f6f3f9cc759272b416f2b5f4d10efb6f707d918ecdde660d8e90166125892254" => :high_sierra
    sha256 "ca854106e2351cba10e09dc4b47b52c5d46dd55079b65400fa724af4717cb887" => :sierra
    sha256 "c7a43c8c34d5851ae7a39ca6b4e579a1ef63d3205d8417f5bc2d3cd171441f27" => :el_capitan
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
