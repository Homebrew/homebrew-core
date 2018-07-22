class Vegeta < Formula
  desc "HTTP load testing tool and library"
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta.git",
      :tag => "cli/v8.1.1",
      :revision => "6f0659435229e0adcbddf1cbbdf9c0adf95f9081"

  bottle do
    cellar :any_skip_relocation
    sha256 "52401d4882d98aef57d695cb3481a6158e8b0ddfc8bc192ff6029fc9a3f678dd" => :high_sierra
    sha256 "25c88db731fb87d4681a314b3b87cc92c5862c0f9bfb2f29c00e536b24d38f16" => :sierra
    sha256 "b2d85acb18a407655a1472a12569af65880c8ed1746669fc30c5b309f8e15298" => :el_capitan
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
