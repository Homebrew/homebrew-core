class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/refs/tags/v1.39.2.tar.gz"
  sha256 "bfd06e36ae049464c71a936e758aa15d7de007221682bab335ba1fa7c351c0b1"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68668fdd1df82cf49f68cd7d8dbc93a23109e3334c1c1866ce6709fb1597f2b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e53d9bd5118b9ffd85eb848fa4949f41f179ab67648de14a3ad858749fc8eff0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f55583b03a0d41bb931205876c698f6db3d257ebb0b67a176af0aebbe8a8bf1"
    sha256 cellar: :any_skip_relocation, sonoma:        "43de189a306e86d95680b691324b7e0d75cfa04558d290efaa09970224325333"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e618b4e9d2ad56b55945038c6cd1516fa70b2af2115b616839c28d1c63db4544"
    sha256 cellar: :any,                 x86_64_linux:  "98356bd51700e653ca774d3bc7e2767f29f0dc3d00e028b109e0cb731bdd7da8"
  end

  depends_on "go" => :build

  def install
    build_version = build.head? ? "0.0.0-#{version}" : version
    ldflags = "-s -w -X github.com/influxdata/telegraf/internal.Version=#{build_version}"
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
