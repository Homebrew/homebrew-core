class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/v1.25.1.tar.gz"
  sha256 "17e7ccd5ddc03caa0067d87a316c977f284b33a7465b535a1641da0f95eebfde"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "979113d2b410456a49423e10deefdb352a6ab53b2b477b4cdb48986c7da1b0e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b871155c4afe804cc481745e3be5e8520d224b5d146bda13e782313d73da220"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac49d1df7dab94f60e65b42a1c338e100bd386e3307a6b6dbf7b3b8981f5754e"
    sha256 cellar: :any_skip_relocation, ventura:        "1514d975d26b62661b1c106bdf6f345fda48311249699d0b94936e9d1b6b0f4c"
    sha256 cellar: :any_skip_relocation, monterey:       "1f407982b238f61141edeecca7a91ea0457532cc0c31e99160099ae5c6c99013"
    sha256 cellar: :any_skip_relocation, big_sur:        "f70b5ecf250efe9b08018407012a4a2b6371992b2c8621c48fe3e59981ea28cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b65c14963e7ceaade95d219c9d6cea2e63aba338f48831c61ae023b174accd4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/influxdata/telegraf/internal.Version=#{version}"), "./cmd/telegraf"
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
    assert_match version.to_s, shell_output("#{bin}/telegraf --version")
    (testpath/"config.toml").write shell_output("#{bin}/telegraf -sample-config")
    system "#{bin}/telegraf", "-config", testpath/"config.toml", "-test",
           "-input-filter", "cpu:mem"
  end
end
