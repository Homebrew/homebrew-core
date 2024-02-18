class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/refs/tags/v1.29.4.tar.gz"
  sha256 "1387ee03ae0d5fb94215c2d091a35697bcfff045dbc3c6e0226643951a3cf9f2"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "475ce5fa71b0119dcab39cc198d7ad2564217e5be6d4053d710c19da245401b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9832a8e8591b35509a7f0083197e63eb02f1bf7f52cc8867caffd573eb93903f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4aa1fb207904c87392bbf58229879d1c8e5f095f04668a90490d1c24f6366a76"
    sha256 cellar: :any_skip_relocation, sonoma:         "d01da04af5f0da34ff596f3b199dc02d606d52037bca1e93e458a74371ca95c2"
    sha256 cellar: :any_skip_relocation, ventura:        "609dfc88d160a40fff2fd4fb8cfe582a5ceb707f9f5fcb1471741bbc11851e41"
    sha256 cellar: :any_skip_relocation, monterey:       "f7196438bf384bfd1fa89dff76aedc8793a242876c26087d69ce01868986025d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14010e80f9cdbd77ea897ad90225ebf1c72e5848c508c53403ed8a24f4c02cd6"
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
