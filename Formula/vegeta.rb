class Vegeta < Formula
  desc "HTTP load testing tool and library"
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta/archive/v12.8.4.tar.gz"
  sha256 "418249d07f04da0a587df45abe34705166de9e54a836e27e387c719ebab3e357"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f2ea9a3a871ff2f93ee65f1a5977aece4479835d954026342ac0c5eb523db27" => :big_sur
    sha256 "7d95ea4ba41b01adc23e73959805a728a4d279cac33448685cced10e268e2965" => :arm64_big_sur
    sha256 "63b383f4cdff26cc0bf4ba3e24a84ea6d7485a9a61fe49ac62b09f39c5f01e13" => :catalina
    sha256 "76e2d89891ecee0bfa07e939619683cae2d954bca2c5524a6e87b84c105c6c25" => :mojave
    sha256 "df3853752133b68c20a9d054c12d36d531779fe595bc6011bb1e2d3245e9df2d" => :high_sierra
  end

  depends_on "go" => :build

  def install
    build_time = Utils.safe_popen_read("date -u +'%Y-%m-%dT%H:%M:%SZ' 2> /dev/null").chomp

    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Date=#{build_time}
    ]

    system "go", "build", "-o", bin/"vegeta", "-ldflags", ldflags.join(" ")
  end

  test do
    input = "GET https://google.com"
    output = pipe_output("#{bin}/vegeta attack -duration=1s -rate=1", input, 0)
    report = pipe_output("#{bin}/vegeta report", output, 0)
    assert_match(/Success +\[ratio\] +100.00%/, report)
  end
end
