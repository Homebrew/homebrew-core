class Telegraf < Formula
  desc "Server-level metric gathering agent for InfluxDB"
  homepage "https://www.influxdata.com/"
  url "https://github.com/influxdata/telegraf/archive/v1.24.0.tar.gz"
  sha256 "a0f16c75fced336378e44423130e63286ba754400d3b334e0fe07cc0e3bda756"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ecd9e5a889154b2c4515a8c44227f6f1cca1a5e47d30b4e0bea10f397ac2ce3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6cddb8640321388425c4ed3901ea7597c54171087a9e01ea36ec71b7871a443d"
    sha256 cellar: :any_skip_relocation, monterey:       "7951ca5ff58c48a580de977d2683276e23213326173408875a7ebac427718a44"
    sha256 cellar: :any_skip_relocation, big_sur:        "00caa7e7b6d55b9d2cd9edef6d150d08b3164a217c697da7e5857801fabdba91"
    sha256 cellar: :any_skip_relocation, catalina:       "1b892a86990b754f99031199efbfb5aaf758bee3cd3223839f615efa270d7772"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb5213b5b7bb716a7d9c1c98864d8e91690568dea1a27da611da55f5229df611"
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
