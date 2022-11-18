class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/v1.24.3.tar.gz"
  sha256 "10a10d776ac7cff30077f84c74808e87c6bc1c1b7e0a486881f02081d5ac6bbf"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e065ec7e64bebb37c61c9e7d5c4f77dd2c6e09922e6029d55ef7ff0ffec7488"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d50b5c8fd7483592490daf2b8bc1d623e97d04fbf6197a5f29b3277ae0637274"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "acfab3077cd3f6e0132a188d790db7d723495b15462687021a336727ac6d7383"
    sha256 cellar: :any_skip_relocation, ventura:        "eff44ccbb01ff97639e72c174404914448215a82be9396b1dea4a0352a66bc8f"
    sha256 cellar: :any_skip_relocation, monterey:       "6c290959cdf1057050656720dc717257864ff18a214aa6eab0aff96eab1599f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "52f865c45e9f177cc00f53c2b3f84806c15d566d53138e268833ac3198393e68"
    sha256 cellar: :any_skip_relocation, catalina:       "b38dee94066c25bc508df8407fa4fe643f52f20e492bf68be4c9f0eba3673342"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aafb292f6b51645d44d9d2b2322daa2de2cddbc546a17c78c5730bf93aadf350"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/influxdata/telegraf/internal.Version=#{version}"), "./cmd/telegraf"
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
    assert_match version.to_s, shell_output("#{bin}/telegraf --version")
    (testpath/"config.toml").write shell_output("#{bin}/telegraf -sample-config")
    system "#{bin}/telegraf", "-config", testpath/"config.toml", "-test",
           "-input-filter", "cpu:mem"
  end
end
