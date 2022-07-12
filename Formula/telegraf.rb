class Telegraf < Formula
  desc "Server-level metric gathering agent for InfluxDB"
  homepage "https://www.influxdata.com/"
  url "https://github.com/influxdata/telegraf/archive/v1.23.2.tar.gz"
  sha256 "01a0a5345a2d74e638e704993366f250195210e1f99f967ca18379ae6c2377d7"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ff377d575dd222518f70cf5175d5776fb88ad81e638d0fa5d3ef90e530fc198"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1cc920ca0a9dd0d80451a4df25dcadea37c651209133bc07ead1346c0124a91f"
    sha256 cellar: :any_skip_relocation, monterey:       "72bb8954b8dc5e61ac1736318573acdd123338b9b8b5e256cc10890385b4f372"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed89561d05a954f0cc6bb57db7b4b9a8357d6c093068805752303389dc57c0e5"
    sha256 cellar: :any_skip_relocation, catalina:       "18c86d3a85d6161a5ca88122301625661ecf4efa51e8855ad5f76f8012c14d8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29d3138342050e4238d840262041d7dde25983f4cf0bf92edd63b9db68473275"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.version=#{version}", "./cmd/telegraf"
    etc.install "etc/telegraf.conf" => "telegraf.conf"
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
    (testpath/"config.toml").write shell_output("#{bin}/telegraf -sample-config")
    system "#{bin}/telegraf", "-config", testpath/"config.toml", "-test",
           "-input-filter", "cpu:mem"
  end
end
