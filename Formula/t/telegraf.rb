class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/refs/tags/v1.37.2.tar.gz"
  sha256 "5f36c0fb34f50f6a587e9fc0924521a8dc37189d338d5eab26ed386ff1cb623b"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43b406f5e4f1bd62dcc78ee3386ccf5fc4e6ec152d5be8b6a1a8074ba35b0bf9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "927ca2024883b9653ea91a9c7a79929d648cc737a571dbc5b9b3fafcda1332c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea4723ba6c685c66ab1080ffe2314c16fdf4756d0f2e45e13b9232d656ef3bc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cb8e309426182be4526d06d2d4beba41d74a03e3aa52194813533fbb149aed4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43a7332aa8febbaa39e3343978d6b966d6fd6c199169c696d9bb8c81c58f322a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f40eb9d32405fdc86efee80e8322ed77a03fdf16501629bbb7ef271b07b72c7b"
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
