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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "092cbd2630fbf8234951289e6ac279992046b7fa1d7d1326da6cf30b86b31f3b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79d4957f00df714a2088f6f603ec3d463dd441f8745896843eebb2d61fd9549e"
    sha256 cellar: :any_skip_relocation, monterey:       "425ba21b3c083827c1e91ed28b9cb05b19b1345702b330855fc719569d04bd18"
    sha256 cellar: :any_skip_relocation, big_sur:        "11c5681c2f58bf61d5db96855fd3bbc6ad0549dbed827f5f85a117abf7e2aef0"
    sha256 cellar: :any_skip_relocation, catalina:       "ba78ad0ce38e2cfa5d0141c178bc375a6d7992f654d6acfb41907e95eaff9ccf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6636ad5fdd14f296efe1df61ee0fdc4270a15840d16632977811b14618f397c8"
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
