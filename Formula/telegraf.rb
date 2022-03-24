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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b49ce34bbd1cff2307725baf47868db3389172f06e172c3e2c3bbc902468555"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79e609acd974ec20fad238c86e59373aaaf9b4aafb81cae76fcaa787453778ca"
    sha256 cellar: :any_skip_relocation, monterey:       "fc445d1768343c3442d43dad89251184ae277c41200a67699a1916a711410ce8"
    sha256 cellar: :any_skip_relocation, big_sur:        "a364261184fe6183d2e0038c9cba066b0b2d76035d95918b8fa01d51af9223c5"
    sha256 cellar: :any_skip_relocation, catalina:       "f7779a8a0f45f7401ae5a5afc965a26df9b005bfa3774b670669303e116dc8b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70425f8baf9475479a9cb5650887c49840c8278b96e7f8d62bd14f7f8960ebfc"
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
