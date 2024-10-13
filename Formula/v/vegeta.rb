class Vegeta < Formula
  desc "HTTP load testing tool and library"
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta/archive/refs/tags/v12.12.0.tar.gz"
  sha256 "d756cbe93ccedab4519e27234640a7bcfb90efa24c63b21676b025faa62ba66e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f218f87374db19956afade887249429c7799b8cc379e06afd5c2d5db527229e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c119a2544ff7ab95aaa931f1e17d5748598eca95f929c720ec87094d8e3fbcf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "416e192e973c3090db2ff15f0671289baf9a5c1c22c1dce1bc0f595fc52e220d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4f4c70fece8eecd588b5f99e1d1ae28143f71542d65396516a09d197dd5acc3"
    sha256 cellar: :any_skip_relocation, sonoma:         "eaea67ec73efa19c37adfe621075a3def71ca93cb48f71a5ca0d69723de28549"
    sha256 cellar: :any_skip_relocation, ventura:        "7094b429a7a5977b2b494ef2f3a927b80ff9646ca00a5793c9379b40b87ed679"
    sha256 cellar: :any_skip_relocation, monterey:       "53867eb75b76dabfc099c5106bf9553573aa174344412307d326dba9d750e411"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7e09f0126fe57216b63aea61c05ab241b771aae8d309e5e045844f37d679a12"
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
