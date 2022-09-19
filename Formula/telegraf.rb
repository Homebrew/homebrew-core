class Telegraf < Formula
  desc "Server-level metric gathering agent for InfluxDB"
  homepage "https://www.influxdata.com/"
  url "https://github.com/influxdata/telegraf/archive/v1.24.1.tar.gz"
  sha256 "2aa1f7e358b9fe990984c25da3317cbed6cf4f2c6ee6707549a12d5b634ea770"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc7fdc59c8393797571d3fc01a44bf8867eee93e308cf4b11b842b0711c2840b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "deec8e7e3f51ac916a46f50ab502eb517f47b349278639f461e13e3db711bd32"
    sha256 cellar: :any_skip_relocation, monterey:       "8af2dcb9fce909cf2de3fc7daf5116aa253f1d52522f84afc65cfedb39c13266"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb0fb49f8b67c6db3c67d8aa3327cd3e0bf39e5fbf33e88841951660b9b8f9d6"
    sha256 cellar: :any_skip_relocation, catalina:       "8d1442ed93b3b701e16ff9c5a08f5483e8669a419764080ebfe40deedd5a75dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f93411bbf2871697840b6fee39bafefa93b553b908f0f9698efd0817140ccab5"
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
