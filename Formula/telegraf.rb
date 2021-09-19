class Telegraf < Formula
  desc "Server-level metric gathering agent for InfluxDB"
  homepage "https://www.influxdata.com/"
  url "https://github.com/influxdata/telegraf/archive/v1.20.0.tar.gz"
  sha256 "efb577f4f5985a6a0acb36df140527120e7442468bcb24dd63755631f6e8ae1e"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "718204dcfd3e0097461ce0a605b5aa5b2e9d10e3beaf13eaf0345775d352bbd0"
    sha256 cellar: :any_skip_relocation, big_sur:       "54fdfa8b378e8e5fa56fb7d11f6fe8107aa69f104d249ce02cafcfa52e487086"
    sha256 cellar: :any_skip_relocation, catalina:      "091625049ba63015cff2c074bda92a85f26a307608533add5bd48f3a560ef433"
    sha256 cellar: :any_skip_relocation, mojave:        "4a22540ea4b50964503cadd8e7f460e4238e1cd6ad7e90c063dbff98a9adeff9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42c7680b3f48772df00d71dbec8e17a3826176840a47ccc8bf8b5deb20a49da1"
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
