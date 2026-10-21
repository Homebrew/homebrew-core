class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/refs/tags/v1.40.2.tar.gz"
  sha256 "519fbd63603acdd23f924f36c49b3f31917f9d2469c17f0d8c584be3be29092b"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0135395e1b24f3c114f2a1600225e1d55b82dacdeb254986cd01790417fc080b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8351ed33afecaf02d0dd16493b1b29fa1fe675aaf8d1abab5c939bf969882d8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fef9bfc2ac4c746730c2da8bf54271989d2337dcb448776c198b65d7bab845f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bc3fabe4299dfed8f636a37d0bb26abb208c0edcc10cab104523c4f1e76e7591"
    sha256 cellar: :any,                 x86_64_linux:      "341d41351c0388b1cbc88434ff76095e980ced417c05d8113ac9b09de18e3deb"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    build_version = build.head? ? "0.0.0-#{version}" : version
    ldflags = "-X github.com/influxdata/telegraf/internal.Version=#{build_version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/telegraf"

    (buildpath/"telegraf.conf").write Utils.safe_popen_read(bin/"telegraf", "config")
    etc.install "telegraf.conf"
    # Create directory for additional user configurations
    (etc/"telegraf.d").mkpath
  end

  service do
    run [opt_bin/"telegraf", "-config", etc/"telegraf.conf", "-config-directory", etc/"telegraf.d"]
    keep_alive true
    working_dir var
    log_path var/"log/telegraf.log"
    error_log_path var/"log/telegraf.log"
    environment_variables HOME: HOMEBREW_PREFIX
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/telegraf --version")
    (testpath/"config.toml").write shell_output("#{bin}/telegraf -sample-config")
    system bin/"telegraf", "-config", testpath/"config.toml", "-test", "-input-filter", "cpu:mem"
  end
end
