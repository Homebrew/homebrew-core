class Vegeta < Formula
  desc "HTTP load testing tool and library"
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta/archive/v12.8.4.tar.gz"
  sha256 "418249d07f04da0a587df45abe34705166de9e54a836e27e387c719ebab3e357"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00e8187e3ba614834ad0cddebe1a50402f49da9f387dea44bb08a944df8b5749"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81e5234d266674684d94f92e09fc70504a7c35ab70e89afe744fb93c6c334fda"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d95ea4ba41b01adc23e73959805a728a4d279cac33448685cced10e268e2965"
    sha256 cellar: :any_skip_relocation, ventura:        "c46e7214f55b814c8c6889e7c1bb906211fb8827ebfb50f06ff4a6ac5bddc243"
    sha256 cellar: :any_skip_relocation, monterey:       "5326e65fbdc12cacad9fd86befe186e708f083dde5b0fdb730772bd096bb3438"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f2ea9a3a871ff2f93ee65f1a5977aece4479835d954026342ac0c5eb523db27"
    sha256 cellar: :any_skip_relocation, catalina:       "63b383f4cdff26cc0bf4ba3e24a84ea6d7485a9a61fe49ac62b09f39c5f01e13"
    sha256 cellar: :any_skip_relocation, mojave:         "76e2d89891ecee0bfa07e939619683cae2d954bca2c5524a6e87b84c105c6c25"
    sha256 cellar: :any_skip_relocation, high_sierra:    "df3853752133b68c20a9d054c12d36d531779fe595bc6011bb1e2d3245e9df2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cf44f8e5a57caff8a709f86cf6abb1c4da290afcdddc1b6088658b424c644b9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Date=#{time.iso8601}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    input = "GET https://google.com"
    output = pipe_output("#{bin}/vegeta attack -duration=1s -rate=1", input, 0)
    report = pipe_output("#{bin}/vegeta report", output, 0)
    assert_match(/Success +\[ratio\] +100.00%/, report)
  end
end
