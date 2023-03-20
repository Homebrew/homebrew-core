class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/v1.26.0.tar.gz"
  sha256 "ee6933a16930dfd8b32832f0ed9e0393bb14cdb973abc1a773bfb58976470ea8"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a09af1c30477e67de05008534850c930d513eee2189be1cdefb22bf788e88653"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61088bdb72e8f3bd0effd3b4e7dd8256a615179ed36d365ca75887812d01c41f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf47f5643cb7075f1912a67a354b671cf78cc2683066ddc92e784dc20b234cd8"
    sha256 cellar: :any_skip_relocation, ventura:        "976f9434e7d01d98b5ad69c19eb35928b4e3fbbf4a31a7d8f49ba0357153ab53"
    sha256 cellar: :any_skip_relocation, monterey:       "4a57ec81d232c8a0a0293f352ee3e12c1db10bbef82de1700d83e26c7a1becd6"
    sha256 cellar: :any_skip_relocation, big_sur:        "15da3d8fbbab727d434bee8d13050e7c008b6bdc41d1bc92cc3deee01018e7f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2131a845151bccfd65d829a5114843306b14eac9f2a6fba061b7712326769eb0"
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
