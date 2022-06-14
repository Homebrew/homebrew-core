class Telegraf < Formula
  desc "Server-level metric gathering agent for InfluxDB"
  homepage "https://www.influxdata.com/"
  url "https://github.com/influxdata/telegraf/archive/v1.23.0.tar.gz"
  sha256 "097f0ae89332dd55c121dbb6b5f81b151a0f0418c11d26b430b33be31ca90d0b"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce6527395f5d537b2742859f9993928c00fe508e5a8947fbdd9a36155cf63f45"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3fa6d557cd623137d1296da8c675d127050c9c33571dc0188b7c8106e768df49"
    sha256 cellar: :any_skip_relocation, monterey:       "ea573b2850d5f54562be029f8f91e1238be7bbb2c09f1005b17e8c1e9dc3605e"
    sha256 cellar: :any_skip_relocation, big_sur:        "b18de3d6e5d36998e83dd58544f1f9a69b707459ff545edc23824d20c7b6b5e2"
    sha256 cellar: :any_skip_relocation, catalina:       "e248a93a3bc8825fdb4aa28bcebe6fe49f57be0263f48e8ff3173fe2d842ad3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa33a6fcd5738028c8d2c93af1d51afb594da27c618732816d5c1aab286487eb"
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
