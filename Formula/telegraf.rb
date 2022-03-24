class Telegraf < Formula
  desc "Server-level metric gathering agent for InfluxDB"
  homepage "https://www.influxdata.com/"
  url "https://github.com/influxdata/telegraf/archive/v1.22.0.tar.gz"
  sha256 "7d1624773e4e5c801eaaa0f52b75ee612cc12a975c625077a57cd7dbe612a2b3"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18bd096a97e2931854450977da90a204f95f3d6d094f4009fb877e1df8101620"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33fe37bf8a3410286ab7bd10d929bf54be0625ed633c2bbc9ec4e01c7a7fde3d"
    sha256 cellar: :any_skip_relocation, monterey:       "5f99828a4d30ab5c396976c05ed32f908dccc9c0ccb777e65ff9be913734e00b"
    sha256 cellar: :any_skip_relocation, big_sur:        "c826e0a845820eef49929badca7fa59acebb8dd53f28820198a36bf83fef89ab"
    sha256 cellar: :any_skip_relocation, catalina:       "f61a9bdd2895030ba68f0ad00e76f8e934f36b9fdbb2abac8acb96fff0fbbbdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f30c5ff622841ae78b3455a991a331ab84644ff7266eb87de3f7bb448461359"
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
