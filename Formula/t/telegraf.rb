class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/refs/tags/v1.36.2.tar.gz"
  sha256 "f4d0f3c430a0a8a9f8888c6e6038f8ce58111c1f3bbf222799ed965df94afdca"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84545f022d7e659a630b40d98b3ca0985c92759d4fa8ebe5c9c220b02ecc12e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d78d2d6ae6017e7954c4b9071ae77096fc0c30857d2f7f88dc80900e148ca344"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b942f05fa4ae3fb7d55c9d927dab0c4b4521dc34c2ee0ea85d45aa6413951582"
    sha256 cellar: :any_skip_relocation, sonoma:        "5311c9856c564e7165bab798c174daeb5a0b5a7ab6b280b2569b522a4194b138"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3da6cb26ea1e09ab07ad1fe3fa7141c7b0f9bf191009cf5f8aefb8afdb53b197"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a5e151e876d28bd0053269bdec9f03d23ca62fbd29a24320643143656bb2d62"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/influxdata/telegraf/internal.Version=#{version}"
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
