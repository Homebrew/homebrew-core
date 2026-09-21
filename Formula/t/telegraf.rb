class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/refs/tags/v1.40.0.tar.gz"
  sha256 "edef75c677e2c2d8b32848397fe9a4736a1b81e3c170b9bedf77d952ae5fa1db"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8393647af3c20c81885767a7b37c474aecffe0a6e6ff9ad65dd5990c57de11fa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "516e43c57365e09fc713c2ebf43029f5958f9884ab808735cd134e8f568d0206"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9aff53a6c0e4ebbbdb331705a802f7d6052a5ec23a9f092a80421e4ae79647bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "a2e66171a2110183793433900c5a0d807526fe4ebdaa50ae21d654ff63902b77"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c7239a63f07fbc65d3fd5f812168ae796a04cbdcd479db8b8cb4c25df6de5ef8"
    sha256 cellar: :any,                 x86_64_linux:      "b6478c621e9d8ceff700d0f78000cb81e364dd80a3ee08b1c127cac5878b9622"
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
