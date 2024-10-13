class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/refs/tags/v1.32.1.tar.gz"
  sha256 "6e0bc7d2c839840ecc882a9626a7abbbfd4b17b90647fee5a05ae1881452de10"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b375bf01373b866971093cc0efe7a0a06369c3745f23fa6c82881f238d234c7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0006bb47c484cd7787a19f50510143641c5bf916ca128bbb6673510caf8c1d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "96726087ee5f3d75b929e6b34f8af6619a13b02489fabc58d5bab39b13d1cfa3"
    sha256 cellar: :any_skip_relocation, sonoma:        "68711477146882b123a8286b104c0927f35e6d35f7af1e61f8da1f0ac2c52ccf"
    sha256 cellar: :any_skip_relocation, ventura:       "91500621b73a959050eba403a52886694588cf2b7d82c891cb98557a5a5155be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1880758a21b59c68434a69d24db4cd15e1a3912d63a399a436781629bbd476dc"
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
