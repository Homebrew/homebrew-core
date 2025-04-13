class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/refs/tags/v1.34.1.tar.gz"
  sha256 "e529bed574fa05f7e157098ccccc5b03780d72a9eeb9fa5cecbfde8b518f0ab1"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0436b0af98fffc763f9825953fbc747ad16e687970d10c6a9ff396c3c5560c2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ec8a89fd6d4880a2fd14d4d66ea4aaac844e137265fecc077cafecf4de2d135"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e775058b04ea766620006bb8e361ca569e737a687fc182bae4fab3824ae92256"
    sha256 cellar: :any_skip_relocation, sonoma:        "76df635de645fc837de8aef9986f20a7b742c751d3bc41b5bee1294f416679ad"
    sha256 cellar: :any_skip_relocation, ventura:       "805e14506df56b2664d37c157f394165988ac466ecfa06102d78e7a43d4c029a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f705e8aeff474ae755248e61f8bd0b6f8d8bd2814c88122dfb16ca461a34030"
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
