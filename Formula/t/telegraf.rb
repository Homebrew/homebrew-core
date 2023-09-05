class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/refs/tags/v1.27.4.tar.gz"
  sha256 "bae1e7e9399e3dd3d10de8dea6ba4112f884d3192f6ca9eda79bb3cb5702118a"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "268d84109013cc1c0816b7e4b6e9defb00da5c3f3f24911d403c7ba2e886d143"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "385e13e5ae230497a5472a9e28dac6835867be5159ad7f36d6f4994501e89b22"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7df8a1d12d706c9032d4bf726985ceebac1124acca9f0be31c03dfbaef37520"
    sha256 cellar: :any_skip_relocation, ventura:        "31e9c58139fc6d4ef8ce8fc62fe962e7ea06c555c6052f5ea8bd3acbde4ce847"
    sha256 cellar: :any_skip_relocation, monterey:       "c0b3db7b039d6390ce3e81d591292d0f200e34263d565172d875d1b3d5760a8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "6133474141d69eb64d567e4c1c421eff9ae557ba450b041092dc0cd30a9c6824"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da86d326cdad84bfdf0364d29197c61c82bebdbbdda8d647d276654de37c176d"
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
