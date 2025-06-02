class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/refs/tags/v1.34.4.tar.gz"
  sha256 "11583d98a2f254bb7c0ce83162ca1a52ab46309d3738ec3c420438413c71f414"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "669f412ab6271a3e9f206653c86c508f979263b5c875fb1337340aa9f29085d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "312dbbf4e2393dc7783eb71601433194c4bfce6243f6c1e0caeb086ba29c0fa9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d33d32af9a2aed9ed33199b955ed6193bffa1e58fd9a659a72953434f4224104"
    sha256 cellar: :any_skip_relocation, sonoma:        "1502a28a6e26d2539b870fb49593ac80d379193a34c39bdd5854a0174c2b468d"
    sha256 cellar: :any_skip_relocation, ventura:       "098fa1a46afddf9eb0202af54a03defa695bddd598c7e0be71307c69e8b3a697"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62af02cf9d90be633495ca894f11ab57fc983f651a37b0e2d34295964097b9b8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/influxdata/telegraf/internal.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/telegraf"
    (etc/"telegraf.conf").write Utils.safe_popen_read(bin/"telegraf", "config")
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
    system bin/"telegraf", "-config", testpath/"config.toml", "-test",
           "-input-filter", "cpu:mem"
  end
end
