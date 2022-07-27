class Telegraf < Formula
  desc "Server-level metric gathering agent for InfluxDB"
  homepage "https://www.influxdata.com/"
  url "https://github.com/influxdata/telegraf/archive/v1.23.3.tar.gz"
  sha256 "984612d5d74b014e82e03069c2430b7868cc9c4c40b2215f43dc5533b105fe3d"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe66851fa6f7665ed0873f04320beb3dc8a76b84489dd2cf32a556f466df2f91"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9b05682d9dade205b7e90e513d197e039f23a5125fc4b33e3aad9fd87e9b1b5"
    sha256 cellar: :any_skip_relocation, monterey:       "50175e271a6130a3855b4e6a3bff2952c61c0ca779f19702fca86b08e97f9543"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b742c7100ba322b2d77b4dba4bad5b277ec42ff8926cb376cbfb2b40effe598"
    sha256 cellar: :any_skip_relocation, catalina:       "416a07d11d6afe3c35753561c6707cdfb94a1653524ac2f06717aa0425297eaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "141ffd94da71d6314ef3745dd95bf0980294522650d434d75cc2f2273355ac67"
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
