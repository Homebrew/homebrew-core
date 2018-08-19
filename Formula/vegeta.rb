class Vegeta < Formula
  desc "HTTP load testing tool and library"
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta.git",
      :tag => "cli/v11.0.0",
      :revision => "6eef4b1ad4cb4a0318f031d517eeb232473d7955"

  bottle do
    cellar :any_skip_relocation
    sha256 "47132327a0429026325be9a2337574983bff9c4eb936120817ddba497588a0f1" => :high_sierra
    sha256 "3229a8a72dd0f32c7569f7969580c8881ad5869ec78f9d8c6477385bf44874bc" => :sierra
    sha256 "e39875b2e23dcca9f086e0880ce87a3289f551d91381edae0472923d78ef1a1f" => :el_capitan
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
