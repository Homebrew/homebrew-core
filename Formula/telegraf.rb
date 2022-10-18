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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2932dd04cdd733899e71488432d7e3eea14fde75c23c432b666ca2bdb065c8ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "233ed8d46b9b4e2a0f03494fb1609fbc6d7628a5eb22c19ddc508625e9f4eba0"
    sha256 cellar: :any_skip_relocation, monterey:       "0acc0ea49effc97fee7b13dc3a6c38190aad6584e4956b0f7846daa2e28e1b13"
    sha256 cellar: :any_skip_relocation, big_sur:        "da8f9a3cb1eb380dc912a149ca4e3d30bc7640dfae839e9d91b0eb066e73ee40"
    sha256 cellar: :any_skip_relocation, catalina:       "198803764d822dc223a409a03129e32a0b67b18151dafbe9f4408ce8adf081e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82603df2ab0349637666d8a47d994a1d791400fc43127ce311d1216127daef9f"
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
