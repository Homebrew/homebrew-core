class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/refs/tags/v1.28.2.tar.gz"
  sha256 "48418c1b2b3ddb6e507609d4d146c8e2226d65da2cc5cacf43d74ae8e450aeb3"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47cce7b0afc9f7e4edac7dc3e5b3023c3f9bf99abb8027f57e67707be81d8dcf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "896ff3f41977d98ff7f33c1495d3f3817cf342fcb57b3931454e7e1df9730b5b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32962d12aa4cef456bfe26dffc6edaf259dcecaeb9e36eb34372d9ce3e4a3e38"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce00bd3329f8bca102cf27982ee969d7aa2086928d0533e0be930a013e2f2f6e"
    sha256 cellar: :any_skip_relocation, ventura:        "608966129810445a5d9d47e10d1626b89762d5a89c660ff59963a182898c0bcb"
    sha256 cellar: :any_skip_relocation, monterey:       "b2a970d058249ed29a37686500aa5a6b8ef25e0f1d7eb29a8a84b70f4b2af0bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e98e14e11db1f7d9684836b9f3b13ee0febada8066d88e4f85cfb2c4a16970b2"
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
