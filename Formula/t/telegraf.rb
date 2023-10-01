class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/refs/tags/v1.28.1.tar.gz"
  sha256 "634063a48fc251d2d5c0229484f460e4b4313b2d5291b4d645b364ad081e7b46"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ad31dbf3b5112dc0428cd4d801becaed8fa923a941dc12f85955ea5f2f362a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db223dcdb91d31354c9f95a0e08339b7c0ba40c47e1b0a15ca92249ea736b347"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ec169aff827422af477e80ff802dac32bca0ca14541051af97312a192e819b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "250d06811632900ca6955d1487c62e78d14cb0f31ae9ea50dbde87fdacbae124"
    sha256 cellar: :any_skip_relocation, sonoma:         "ecedf115948715de7b9d3549cdbe297e7a1f073ed8ed32c2b804c2d9bacf2ddf"
    sha256 cellar: :any_skip_relocation, ventura:        "0946faf65e2e728a4209b38b0320feff41367eceb212ec23b6182db250cbdf59"
    sha256 cellar: :any_skip_relocation, monterey:       "ab94d367180a31d24eefe689556424c36a822fec85511d1d7dbdd41ab5a728a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "681437fb9def02908647248eb76b1d169878812660a239e36a3bc639d1f70c93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce94a66ddad8975078c27236de1db1c8f00d99b7d387fa0620ff3e58a32c7c0a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/influxdata/telegraf/internal.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/telegraf"
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
