class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/refs/tags/v1.36.4.tar.gz"
  sha256 "d4f647b3ff995698e4490cf9f156ec6d53552cd16287782a196c937ff8d748c3"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9d5f080e6b6632bdb084a33f7ba51485a776009cb9836ea47f67159e194f7f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b63a624a745f95c62d3cd702ab8d60b1d2b15a96fbcfecdf6c055b25f434fff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c26eaaa168ecde7959e162c1ac56ba05b8a9b1168d32b9efc2f6606e7aaa7390"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5a98bdad98a29456fb46882f14d1a81b8ef09a5371dd90b78a24e8a0bdf03e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3478a0a0f7b3544710911b8575dcd309eebcb1c11710170365f33a1227d9b1c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29be7a32c7ffd7236307ad7c41862ea1a21c18ec83465c303fcea64304602e8c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/influxdata/telegraf/internal.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/telegraf"

    (buildpath/"telegraf.conf").write Utils.safe_popen_read(bin/"telegraf", "config")
    etc.install "telegraf.conf"
    # Create directory for additional user configurations
    (etc/"telegraf.d").mkpath
  end

  service do
    run [opt_bin/"telegraf", "-config", etc/"telegraf.conf", "-config-directory", etc/"telegraf.d"]
    keep_alive true
    working_dir var
    log_path var/"log/telegraf.log"
    error_log_path var/"log/telegraf.log"
    environment_variables HOME: HOMEBREW_PREFIX
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/telegraf --version")
    (testpath/"config.toml").write shell_output("#{bin}/telegraf -sample-config")
    system bin/"telegraf", "-config", testpath/"config.toml", "-test", "-input-filter", "cpu:mem"
  end
end
