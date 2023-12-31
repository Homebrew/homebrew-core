class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/refs/tags/v1.29.1.tar.gz"
  sha256 "85c1db150023ddc207c01a6189b3fd23c4dd9b2b1bc3d098fe752d3f290f27f8"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59ef79e2afdda242bb944c0b8722efcd852528fd66fa74c919c816c87183dda7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9953f5c9f06d09221d34bfe90d962aa402c74e3f3a7f80b2578c050802908baf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af308687b9735333cb41d5c2020581468f1f2798da88843fca684e28597f8ae5"
    sha256 cellar: :any_skip_relocation, sonoma:         "890ade396fd1dbd0c40594a5eca07532bbad3a29601e85ca581228c7172ab40c"
    sha256 cellar: :any_skip_relocation, ventura:        "6c3f33dc561fa97695de571a32729ae3eed90ab8a8581654424bb02c5a807d30"
    sha256 cellar: :any_skip_relocation, monterey:       "7b9ff3d37ac40e48f6a076e6286fbbb98bb7dbde951358eb2454f239ea639e1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e3300b51681651ec1966f68964380480681637d1cef99f45a2581ff13b5d93e"
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
