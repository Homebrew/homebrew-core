class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/v1.24.2.tar.gz"
  sha256 "e0b4bc65dc46a87b14a164c1226f6cee15fabfff14f355344bede3ef3e585925"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb43acd8fd419dbbca6522f255d69837f83bd7111975b9a61cbf332f1b9c775d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "904026e81ad0d1520d50b16d51533b0b716cce5d0f9deb06b644e4e2176e2979"
    sha256 cellar: :any_skip_relocation, monterey:       "4aacbe6dbc4e31ee645936395862c9085d2312b103f294d7fbd321a19cd9881a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a8373dd564f3a06b8cdd5df33013fc2ec799b567c79ccfeecccc1c0555cd61ef"
    sha256 cellar: :any_skip_relocation, catalina:       "5e8bcc8f284f6ff2f1d59b63ac0d39d84f01bacc3293eafc9600309b83dceb26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fed31e2afdc85bf8a836d9bb358bcf0ebfd73c1b3c3f52ecd1de549c0d00f601"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/influxdata/telegraf/internal.Version=#{version}"), "./cmd/telegraf"
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
    assert_match version.to_s, shell_output("#{bin}/telegraf --version")
    (testpath/"config.toml").write shell_output("#{bin}/telegraf -sample-config")
    system "#{bin}/telegraf", "-config", testpath/"config.toml", "-test",
           "-input-filter", "cpu:mem"
  end
end
