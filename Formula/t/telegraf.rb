class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/refs/tags/v1.39.1.tar.gz"
  sha256 "687fdef018d85a275015d621653061251d6566f53b9b41dd5c93c21019cd92f2"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15bfaee790d5c20139da00ec04a4c13e33ba182454c0a4d7eb8f6636153d8f55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5dc32984da891f3f7f307c9734871f3c87fb738c81e7b59f70f9cff28e675ddf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f0b084897cb1cd857a4bdb4381ce0f717f71af6d5d0d661c00a887dce7c369d"
    sha256 cellar: :any_skip_relocation, sonoma:        "886e004021690f41e1d7114d6b693b8b05477c681f7f2f546a129adf2d950a7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b460a6aeb87e8bb46206fb3d1ad3ab89ae4cb57e88687926ef2fc06fc21fdfdf"
    sha256 cellar: :any,                 x86_64_linux:  "b786d87e3a502dbe22c99611c989dfbce01640652c49f164359d8ea8ac913f49"
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
