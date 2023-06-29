class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/refs/tags/v1.27.1.tar.gz"
  sha256 "9108c2a063d104fb6652684d43b5854c086d6c7e19e3ada34759ced7bc3ea406"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08fdc3ccb3f1303f839d22cf5076fde29a943b4b1cd789deca24e6ba26d71732"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1700c25273e2cafd0f4ca99d7ef9a82566bda0687225a918b96a1bd2fe6d7cc1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e35b52d997ef8ed1bf1a7c746617159db5b7acd4f67c4a1eac6bd0eb05c767a"
    sha256 cellar: :any_skip_relocation, ventura:        "b84849fa1e255b33c811062740a1dd2ec2bd01889398a496edf465faaf792fff"
    sha256 cellar: :any_skip_relocation, monterey:       "69db09f9b67da052b6118e007b0c1dcaf760ff25f4bce3621f324b41787fccf6"
    sha256 cellar: :any_skip_relocation, big_sur:        "5dfb2d0b868b381551c72761dc0675c3480d09228abba6c9f4943037442e592e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fcccf470fe6cd7cc927d1722e5d7009713307c36866052520b1157f91047469"
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
