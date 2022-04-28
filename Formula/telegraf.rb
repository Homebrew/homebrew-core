class Telegraf < Formula
  desc "Server-level metric gathering agent for InfluxDB"
  homepage "https://www.influxdata.com/"
  url "https://github.com/influxdata/telegraf/archive/v1.22.3.tar.gz"
  sha256 "1c260902d713ede64e6004557bcf1c545c7e0f4a543a1f6f84b60b5254f6c266"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2791223a5c8f20194635de4a9af514efcb8e71b053b27f8d4dd468f1ef15854b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73e568c91adef31334eca71f174942ee523f3bbaa632e16f78693cd88b11e3d9"
    sha256 cellar: :any_skip_relocation, monterey:       "a42092f81e5de053e34584cc26ec363198aeac82d153a295ac484f16e179ec3e"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e6cdfd87bcf01bedd4aad43b21067596f8abd18ecc663a44d0e61b0b673ee2f"
    sha256 cellar: :any_skip_relocation, catalina:       "0b096f0441a874d068aceffb12b2e5e388a333510c5a4cdccc280a2fc2f104e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "404bbe90da1d21cb4ccf2c917d6b13724018124873c643f9805b9c3345f086c4"
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
