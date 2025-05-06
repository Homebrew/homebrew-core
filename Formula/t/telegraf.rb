class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/refs/tags/v1.34.3.tar.gz"
  sha256 "0ba7a93a4c4a7b0b854c57edc342c5eae7791851af0f2c23fa2b0cde64016155"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f95e397e2f84dd4c2d4ce773f353b5867f67bdec747786186e87e94b7f2ed32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae9179f26f7e9103d6b76d0ea67fb7ff66c10365e87a7a93d2dcc446ee7855c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b507f2d47b113d0c777274403c3d4d56ed10cf4079693268057611a7775babf3"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7aab598e9afc2658031fde0c6ff7b23141753472a3e16825a84433b144a0115"
    sha256 cellar: :any_skip_relocation, ventura:       "28bafba30d69ee9319b099b59a5d6d99238ef25719f2ee0dc47590321d517dde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a382800f5c04a6e286744c7dae3bb41514f9ee283103bbf6f4f21a3ec53be13b"
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
