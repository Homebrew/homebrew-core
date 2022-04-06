class Telegraf < Formula
  desc "Server-level metric gathering agent for InfluxDB"
  homepage "https://www.influxdata.com/"
  url "https://github.com/influxdata/telegraf/archive/v1.22.1.tar.gz"
  sha256 "ccfcf7ae1dbc1c99f1362742f1680ff7e026a93a90dce82c73de4ff21aeb01dc"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a73e8fe403c61f71fcd944ac897777b50f1b26aac309b6eda49d30144ec8f3b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e88d76e3f86ecb364ce350e5b43edb644811193f71ea347e5b1ff64e60292da"
    sha256 cellar: :any_skip_relocation, monterey:       "88ffab9d347eb9c25c716e6a814bfb3ee0bf302c71a6afb7552f75ff40f9e02d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0384f1aa61af05ac7900d4b3c33680a89b928dafa317b16603923ee9bb4d778"
    sha256 cellar: :any_skip_relocation, catalina:       "b766f99a09a3d2d59ad4203c65f0b62daa1fca496fc1ec8641af7b789cb6d3ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "584bb3721c194eb70523de249914341646f4e288d353d4522f2bb817554e0d31"
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
