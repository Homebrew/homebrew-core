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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a41890b558fc99569d282d6c6b6bf1e358160549d5fb6c5c22226d1dea8a86e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f567027014b56da4032fefefd8ee4a9f0feea4080571462550fe5aa62bb7d76c"
    sha256 cellar: :any_skip_relocation, monterey:       "32b04f646455ddcd58bdc9ae4beff6727a958c7d4e036376f4b267f54ee1792d"
    sha256 cellar: :any_skip_relocation, big_sur:        "a14956a67c8f42d469b259c6674a3cd242ab1d50b132551abac52ad7ca2753c7"
    sha256 cellar: :any_skip_relocation, catalina:       "481113229c6df9284632dd4c4b10bdf4f4c030b4545d13bd0880fe168edaaaeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7e9d6315e8cf62919de7aba4fd5f5999ef17380cf8ab49adbb3bf7191107a77"
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
