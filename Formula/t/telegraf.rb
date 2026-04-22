class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/refs/tags/v1.38.3.tar.gz"
  sha256 "83a8119b09830eb7d9167563add221335d0f59a22499919741ed539697a6fa45"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c141ebbc61a52387d12fa6676f0d1aff01d4ec98f09f6a78c1cd79cb94cebcd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b85d87895ce0d392935b46eb380caa966e858bbe17c1080aa13f30e5bd952bd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c435fa96170f48c385ec8d91caf1ec5cd0b78a43f35817b641906868c73f7073"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ae8d39da2c88142b5cf10fb9c6c90b1cf432c1446dcc0d4c60d0a9ab93e5b33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2e80e03df7a6da075900d543f64abe4e9176b2cabe197ef9becb33f4511b288"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b5d218f091e6fdd3fa56456b5409df6e936623422e9da45114204d91dedd34a"
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
