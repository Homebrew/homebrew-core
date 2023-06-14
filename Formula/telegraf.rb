class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "9530283b6194f3e2c50343dbbbc48a70d05d138c5baf558d00817c69f2adb870"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0839afdbd8adc799ec86a73df134e401913859deebf97419b86526114a945848"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f5613e383485668de54a9f2f6e5501116dd367eb1c2debc60bd471efec10e87"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e24de0c7181edc3cddf8c4e36b90c274c52744acf0cb5cd2386be78966501156"
    sha256 cellar: :any_skip_relocation, ventura:        "c9366d4d9860863513d5054ce2c7523fefe867b96f802b8203c8534e036bf749"
    sha256 cellar: :any_skip_relocation, monterey:       "69fa37515f36c1b9d7f84848d09dda049921cf7d842f1467167680c1e3397434"
    sha256 cellar: :any_skip_relocation, big_sur:        "cbb0170d1c328b860df483ad1d1dafe1754064f3ac40f9bd9416505a5c322862"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15eecc331d7539d24d21bdfc0b63b72abecdea9f8d45b66ec6cd9d477da020fa"
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
