class Telegraf < Formula
  desc "Server-level metric gathering agent for InfluxDB"
  homepage "https://www.influxdata.com/"
  url "https://github.com/influxdata/telegraf/archive/v1.21.2.tar.gz"
  sha256 "2a6c0722c6999c438d316d5971502aa79abd92134c265ee0e53596cc125d175b"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "702e257b8b8eb0f65fd24fb2eb7c961436e5ad65c55a1b31e3dbf8591b62b197"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3598e69c5245107bf46bea0abd6de8f319c08e1696ef2eebe11b297d25c3b314"
    sha256 cellar: :any_skip_relocation, monterey:       "0d865c4c924446374864d814f1a0f16febdef9edd5646b0b9228103193262ee3"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa82d48ae0a479f56ba6a8bb456299a4671d625b2dd8edd603b48b308d2d6871"
    sha256 cellar: :any_skip_relocation, catalina:       "ba9c48238d7d309329db96dc889ec8bd9a35411190a6de70b4d47f1fa9b8c0fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10632c4a21dcddab28c895be50522d926afa3039318ffba082eee4bde0144c36"
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
