class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/refs/tags/v1.40.4.tar.gz"
  sha256 "1770b4eba7e3e7885928c29b7aa09fb438ba2f1e1b4ababf2411ae50b2e8c537"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "6e4761a410ca9c1b1d6864305f0296bd48fd2fa538bbdb73ada16291479685e0"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "20560948692a8d8057c3f730458dca656847b473ab32060c2a5a75802c65f90b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e8c7856f6dd6ebe67f30dca062d2e2ec8924992e2392aab422c1c5e4db23fcaf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "507d5e6d8fe3a30f81a14c9d5d4747248c80b7ea200984dff0c3a1b268d974fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7d110e0bd52ff0ac011d160b83d373e95a6dfe159c6d7577ee519e07e8faf799"
    sha256 cellar: :any,                 x86_64_linux:      "7b836c66424171db5746c42f65317f8af7b3769ac70903bb5d652ad2f5f29067"
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
