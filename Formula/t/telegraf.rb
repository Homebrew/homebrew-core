class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "ec86fa035040208e81a2e8ccab1c05f59b975111fb527a3f0f5129ff3b8321b3"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0a3971e7b98120345bbae20144f12d89217f6638fffdd8ab1c9c6347ba2b6039"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94a88dae2fc00ceaba3e188c5662f7742722db0cbc3640e68bd5eaa730d609dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c5b5ed754454ad0081139b08a45919333b162e5411c50d12e633afe1184a2ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "adbc69bba1b7b3c476c4743a0cde324a96af705e63905be48a0e53b384096acb"
    sha256 cellar: :any_skip_relocation, ventura:        "60ec81a5d24c38b42ebd4a21b50332c747f025ce79e96458e50fc7e534198a69"
    sha256 cellar: :any_skip_relocation, monterey:       "f0a06474ff8aa6aeb6caeb24c2b716729fdb566109958bda64cf928214d04a0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07503f6722eb7da2fc403bc9bd52c9718892f37c8319cdd9e1600f2ab242822d"
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
