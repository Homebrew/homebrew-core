class Vegeta < Formula
  desc "HTTP load testing tool and library"
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta/archive/refs/tags/v12.13.0.tar.gz"
  sha256 "0a3d46beefbe2df2b9c448f383fd574117bcc56f2b2d0965abb9e2b49979567f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "118cdcdb82aff12be53c7cd2272d36ca31288e61849ae091bfe82c688da332a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "118cdcdb82aff12be53c7cd2272d36ca31288e61849ae091bfe82c688da332a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "118cdcdb82aff12be53c7cd2272d36ca31288e61849ae091bfe82c688da332a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "51ba41ac0959aabf05e224a8b84ab980c21317fc628831017c1af852cdffa744"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf74bd9cd8c59b3727adc2fffe59ca2cc1fe74ebf227d5d686fc582b9c277985"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24296d1e26a30ef08357173a325629f85901c8ef49a69aa71ae1a8fb84ebe8c6"
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
