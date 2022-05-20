class Telegraf < Formula
  desc "Server-level metric gathering agent for InfluxDB"
  homepage "https://www.influxdata.com/"
  url "https://github.com/influxdata/telegraf/archive/v1.22.4.tar.gz"
  sha256 "828172fd3125eebc9777f3a4b42c5292bc85d6d87e4a5b41a7bb1b3e6fbc7d2a"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6f8bd274110e5f937da6079ff818cbac265fedf6d71d6d334edfaf242d3ea60"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b91d040b38122e853be473bc5dec9f75b2ac108359d47aabbb3056b797bc2ac9"
    sha256 cellar: :any_skip_relocation, monterey:       "e8fab1e9ccac5dd07bad730ebc592d67d6260dcdd787a25af73a3e023b7df165"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f6a1a7c0b09b9c511bdb3389f131a73f2df5c1f4fc8d77e6728993b821fe5e7"
    sha256 cellar: :any_skip_relocation, catalina:       "a1a1ac82f7d4f5bea88a0308a7791dbf23f9df483363d99e138ffc6c682f25df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59d6cf04f6c84471aec743fd769413caee9b578d088fb71aa80432db146f9f89"
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
