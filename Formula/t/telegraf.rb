class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/refs/tags/v1.40.3.tar.gz"
  sha256 "27bfeaf8c56cbcffc289065623ff7e3b0ff9e48c1d9c00e2278ed453900a0e66"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "be1f9e24bbb10ab0c5d7e5988631709d008babba3f5a929ea4e52e6bd25f1665"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "04c8788ebc87f9dcb6bad8613eaaa767abb4584ec9acca545eb8e4c4f894f169"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d6ca5c6a716670110c7ef46eac6ab200011463364c16327446c763c751b7f289"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9417cac6dd8ee32dfc06250873880ad37e6c5b3c2055e14c6f7627a2be048764"
    sha256 cellar: :any,                 x86_64_linux:      "646f722449b13e512bce937636264bcb094b98fa8f21cca96b65bd9a7d226c6f"
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
