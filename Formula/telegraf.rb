class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/v1.25.1.tar.gz"
  sha256 "17e7ccd5ddc03caa0067d87a316c977f284b33a7465b535a1641da0f95eebfde"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40285d8dd6372f959d250558358629b0232bd6d3206a90cc421eb755d5196008"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcd53563689d3e0a3632a925827da8ca4cda7e1c4f0570ca7915e19383f6f148"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7db7c9c70d3fdab1fddea33bd4eb1d01f04a48131f23687393f43d81b1b35b06"
    sha256 cellar: :any_skip_relocation, ventura:        "62100c6642d74f0bb87a6055ed17f77cb73e94c8a8000539033c38c788196deb"
    sha256 cellar: :any_skip_relocation, monterey:       "c32d4d5dd5e1ab1df317e1f3845fcca561c6d80b18228c066a58e1fcf963c77a"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa47f0eb6b22f98f998f1f61ab8944ccdc0224733243aad841c351fc9e0917b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f0f8909944c9de1f7879aff33ac8ea451f1eb1f9b4717f29e03c2cbd6f7868e"
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
