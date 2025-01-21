class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/refs/tags/v1.33.1.tar.gz"
  sha256 "de35e93b84f71b5698d76783404b8aea351702828d127a8fdc4108010f299da2"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "002cba94efed39a426f06b3b4ac925a5a9e8c226be14295f711595cab8347703"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5da6c404414625161e60fac1a64d9061fa7afccb889ab2fd356ba65dd219af45"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "272b90faf143ec7af58ccd04420b7b5d9f8b85f9e8698cf0eb734998378a4aa3"
    sha256 cellar: :any_skip_relocation, sonoma:        "6691f732485c531569529abc34485a3d13102367ba5afe997f88c4d0619fed31"
    sha256 cellar: :any_skip_relocation, ventura:       "db3e3f707d08db3eaa2b27eee6db1b9c1cc04737ce6ec4ed662eb65c46456e0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85515117b8cd51bbbbe38b54f8ca7005a1d1c2d42024335e020f9d6003355112"
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
