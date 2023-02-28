class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/v1.25.3.tar.gz"
  sha256 "b2b0ec6c1f698a8f5f8af75cf932a14e53b2eff57f959c4bae8d6c71dc363773"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "731e62b846be57a24240cd197d1ab27ebf523c0494356caa45bb9ad1e9a84f20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d9ade4ab4c3921ce1e818614f971be25bbf80853076f77c4f095cbfc9018f43"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2375e5e6a39c8c5b0b9d2122276d1c51603ebfe6f5596d77346e8e11f96bcdf9"
    sha256 cellar: :any_skip_relocation, ventura:        "3e8191c7e12d27b277c157e49b05ccf89087de2a6d4eb9ee402f157c16390655"
    sha256 cellar: :any_skip_relocation, monterey:       "4a26f08b15615e3d45ece15cde682df27ba10610c4c8e1a15b2b164d905d4f9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c0b369f1e34d54758601df1c0b09919a4d07eb3c730a4758e3a26da1b194115"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b0d2b217d7cf8a2f6f6f75a4dde8599e908faca94bda1d276f477ef5990efd2"
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
