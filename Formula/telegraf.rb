class Telegraf < Formula
  desc "Server-level metric gathering agent for InfluxDB"
  homepage "https://www.influxdata.com/"
  url "https://github.com/influxdata/telegraf/archive/v1.19.2.tar.gz"
  sha256 "a92de0b9b30d6dd4348ea5b05c0883d95149afb4add452a249e1fbe903025dd9"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "456c7e1a8a93f7f0b2400a7b4e76e9f0988e7f6e6b7a874bca6f653a61249ebb"
    sha256 cellar: :any_skip_relocation, big_sur:       "4ece6b8ddbb5508f4e05445385d057e01e15ea7de235cdc535ef5d4d8a322d7e"
    sha256 cellar: :any_skip_relocation, catalina:      "b625daf3fac433733d784cc12627a9a85967fb28f25731aacfe0b99856563801"
    sha256 cellar: :any_skip_relocation, mojave:        "ff9aa4a395bfade5554d3a98931407f8c55693ebfdde8443d74f286bd0b2b5bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b71909e8d0b8364c1a8de269c61c76831ed4b636d0c840422a27c1216fd3486"
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
