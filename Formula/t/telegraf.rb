class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/refs/tags/v1.34.2.tar.gz"
  sha256 "2a7ec0fc4e121e074cea0579f5e72e4a321958ccc9fe7b36c59d8e56ac96e5de"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f21030b797f6b31ffa798010f5939060c3dbc8b3d63bac8af0f964d4e4b0ea4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5382c2982ae9c4666ed47b397c7b16d7298af79d35c85e7a381a5a49c0d31ab9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "857e327e81de0436579e0d574204bc1512f289935fb059a667121c7e8f4e15d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "857744edbcd01d6e6193a6d656dd2bc5e039136f17f5ddb73df1d1e5c26d1c48"
    sha256 cellar: :any_skip_relocation, ventura:       "74c9612b8062975326b7fece2d31d4c60ab6c70d8e840c0a440376cb616cd65f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e717344d0b69ce6c326f50df7a854d6204305be0078ebdef8fd07c605eb0d732"
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
