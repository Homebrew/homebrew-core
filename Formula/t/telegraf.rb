class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/refs/tags/v1.37.1.tar.gz"
  sha256 "14e9ba382999a5065a86344af73891b977aa8bbedf39f17d1f549b3e7575b645"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b49304926a6a9e14132351a9ef03771301f9a7d2cd5bcbf9c5cd3dc106cd614"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99a0253350fdbf06774f97087e011eb9b6ac78b4289e16e4922d2257e196c444"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bc8b33c460bf17da8c01019b4514a5f06919db87c705df97ba0e34c95bf88b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "8032939d7a1be6ea2ba5eb6b6b817b5acfc71d02771234c82342c0685db507a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "964f2dae3323a9449e81a1b40408bc1b89560577d1618feb007ac327b4e61ded"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ac3ef0f16e64283a46bd21d9effa79c98c541d0f118706c0d2daf050eae5099"
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
