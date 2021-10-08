class Telegraf < Formula
  desc "Server-level metric gathering agent for InfluxDB"
  homepage "https://www.influxdata.com/"
  url "https://github.com/influxdata/telegraf/archive/v1.20.2.tar.gz"
  sha256 "3b0db9f48a76bb5076eded0ceab6ea568b295bbc525cdd8ad1ecf700ef317c18"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "530670e47b2e76aa13b7749c4fa70f4626b2a0eb7fd5a36ea86ffe726b8d6843"
    sha256 cellar: :any_skip_relocation, big_sur:       "8f15f1c9072979c7e7e3f68a7df2e4826bcf5cd798cbce89d13835b79b43b578"
    sha256 cellar: :any_skip_relocation, catalina:      "082371afb008e3e8af2cdf185a682697276a01eb8c7dbf0b6f62e7a5eefb263a"
    sha256 cellar: :any_skip_relocation, mojave:        "a7cc6d47990e806efc00532872368424f6154ad44579691c538b9ed08bc88014"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3647f10e0d9e053bad2dd75f4d153d56e619f9a50b3ba94e63bdf9fe4d020117"
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
