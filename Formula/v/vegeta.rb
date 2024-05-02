class Vegeta < Formula
  desc "HTTP load testing tool and library"
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta/archive/refs/tags/v12.11.1.tar.gz"
  sha256 "e3e65be2c79195aab39384faf15950c2c2fd61f228f6c9255c99611ac6c8f329"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d3f743c61cd826d4c611061af53d0c6cf5e2b70d42d54630db040fb5798fb17"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62faf9ecc4089759e9c782c33cf34b24bdeb50b470eab67e12e0fb0cbdd2b8fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fab14bfcc18db3d64be4256edd61b82349b30ede664ff017fd29410c8574802e"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff74c614c34dac4a704446c5db4d2de1ebb195fc14a51fa40714a8a9c085604e"
    sha256 cellar: :any_skip_relocation, ventura:        "37d13b866dd899ff8e1082f7ee5783c7b5ee9d0d913ac32044cc3d9d53f4a9b3"
    sha256 cellar: :any_skip_relocation, monterey:       "8bfac80c5d2aa6e8dfc42cb6108d93dc3b5842733030839cf3c88f6132e913b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2d0369cb0b71d49054f42681a19631a1170e7c84bc72844ff6400189ff713ee"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    input = "GET https://example.com"
    output = pipe_output("#{bin}/vegeta attack -duration=1s -rate=1", input, 0)
    report = pipe_output("#{bin}/vegeta report", output, 0)
    assert_match "Requests      [total, rate, throughput]", report
  end
end
