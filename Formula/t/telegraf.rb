class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/refs/tags/v1.31.0.tar.gz"
  sha256 "c7a4725aefaf6cab4a354c577e06032187ce1c428337c795e48bbe7d7054d489"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c1d047507fe45da2c3712cbcda927afcbfcf4def6b629b10fce3ae1e28d7943a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7ad61cfe91d0d5d4c1ce3fcdb9e5d0f48b7d1d897750751fc01cbcbcab7bffb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84645b9d3e2e4d1618a95b75080b427ce83b09804601958b1464a55bd8ee20f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "88fc384a019fc3fd2bdffd9d7531b5b573278af8bc90895f7bc28204dc5f3347"
    sha256 cellar: :any_skip_relocation, ventura:        "990ebfc0b9753b0a167994c0b38830ef54774ad7b9de6df05b3e260aa34b6103"
    sha256 cellar: :any_skip_relocation, monterey:       "d08bec8715a98b8cbb5d77b6037307ae0aac4170eaaa1b8d74eb3cb115c6c573"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce6f2e74fd755f60e3089ffad143f0381e16b12e5950bf3a70fef48bbe5659b0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/influxdata/telegraf/internal.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/telegraf"
    (etc/"telegraf.conf").write Utils.safe_popen_read("#{bin}/telegraf", "config")
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
