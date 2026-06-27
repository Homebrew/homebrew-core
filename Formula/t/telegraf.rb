class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/refs/tags/v1.39.0.tar.gz"
  sha256 "d072c38088df3ed9c6ed737ff34d6411c2796f231dc6ccdc5d7da3df69cc2838"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "494bb4ff5e05d7c843ec6bc0dc489db1af25383afd5f92963fd5e5c76c85e173"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c5096da086aa980a19e87f99773c1c90d42bf5952d39466b1c2d3848b96ba29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cadf4130697379f2440dd4bf8de3f954fe096d445ab7839dd76c349147225ea2"
    sha256 cellar: :any_skip_relocation, sonoma:        "81fe5713bb79b29a5be86755fa36b300bf2d5cfdd2d293788e8b533ac22cb879"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "655e112e5f7b693428732795d48d885833852215133ebf219931640d549beff9"
    sha256 cellar: :any,                 x86_64_linux:  "005cea4727db4e1f0253f3c5f1b06ea0dd96c01a52facdfa08cbb8e4ca4a7f01"
  end

  depends_on "go" => :build

  def install
    build_version = build.head? ? "0.0.0-#{version}" : version
    ldflags = "-s -w -X github.com/influxdata/telegraf/internal.Version=#{build_version}"
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
