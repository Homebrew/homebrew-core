class Telegraf < Formula
  desc "Server-level metric gathering agent for InfluxDB"
  homepage "https://www.influxdata.com/"
  url "https://github.com/influxdata/telegraf/archive/v1.21.1.tar.gz"
  sha256 "7ec38fa53747682290621b3162dbb0bb12cf73a559a689f8a75e1ec8b518da0b"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd2af97294f4be3520c577cabdb7d9aad0aec2062b5004b0c7e62ceb51363876"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f92247f0ac7e97957e4ab7df252fede7f878682e4e9c36b2503752614b3e3b8"
    sha256 cellar: :any_skip_relocation, monterey:       "b3b63ca9e351cd897bf50999a3958f8744f9d9851055ba4b2d2c6d65fdee6347"
    sha256 cellar: :any_skip_relocation, big_sur:        "bab8e8a7e0a31e1252c8dd511b98cf1ed471284d52f747153fb146b30f2466c4"
    sha256 cellar: :any_skip_relocation, catalina:       "eeca80233a9e2f3c29e752dc99239ceba9ca97f474fb09251b7fdd78381db215"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ff5cfbf6a28be8cb3640e8961d6c3285a4d9a49a32a1c2ac8f52c29a450ff49"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.version=#{version}", "./cmd/telegraf"
    etc.install "etc/telegraf.conf" => "telegraf.conf"
  end

  def post_install
    # Create directory for additional user configurations
    (etc/"telegraf.d").mkpath
  end

  service do
    run [opt_bin/"telegraf", "-config", etc/"telegraf.conf", "-config-directory", etc/"telegraf.d"]
    keep_alive true
    working_dir var
    log_path var/"log/telegraf.log"
    error_log_path var/"log/telegraf.log"
  end

  test do
    (testpath/"config.toml").write shell_output("#{bin}/telegraf -sample-config")
    system "#{bin}/telegraf", "-config", testpath/"config.toml", "-test",
           "-input-filter", "cpu:mem"
  end
end
