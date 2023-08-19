class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/refs/tags/v1.27.3.tar.gz"
  sha256 "da4bc911483ff90f8c2c6ab230fcf329eea094baba423b55c9196b3214f3847a"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f8269fb8a50bf1e9f20c2e2cbf5d5d74da46f90b79f535970af9e6d258dafa4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10fcdbe54125cc0e1ff85b16273f6d0371e41c080b63c6e68fef9ca828e4e9c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "580f2fdfe2d24946d6fb5fa6bb933ba67b6424d53217dab01c9d3c2b6e239e8e"
    sha256 cellar: :any_skip_relocation, ventura:        "097b335aab4b9a349402b07c9e8d96296ecbbcbc9692d575546e741ea8d8efda"
    sha256 cellar: :any_skip_relocation, monterey:       "3d9127eef9991497e5939ac00579ae8d5777b2dbbfb767b7ae01a93898afb955"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8a0fa1b64d15efd5afa6fe7065a2b3f6d4ff630ff53951a15f61dfe208fa33f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4edffecd726c3265377a6c01a44040807f42d8428e9fdf7482e626dca5d3037c"
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
