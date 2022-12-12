class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/v1.25.0.tar.gz"
  sha256 "b93f001e5feba0ace5aa2286d55896d2e0cb8764b68ab001304c4d2f35258017"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10a80e6b66711bdf855d13ca6b91bba72498da88c13648af5918df9fa68ce749"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9eae7f66b6123f76355332e15552686c70a2ba2f49fe78772d5578e9cb13f9f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ead60441d42743495ef2bb3b90884cc0a2860d03e7bfa9b653c04a8e15ff894"
    sha256 cellar: :any_skip_relocation, ventura:        "e1be384116e8f86d4053b3c3b7bc1bbfefd8b3d7053d9d30315b8cd0e4ea1400"
    sha256 cellar: :any_skip_relocation, monterey:       "5e837004cb3226a74f25481804b4056bbd128e5a2b59dfb44fe20a421ba76d50"
    sha256 cellar: :any_skip_relocation, big_sur:        "123cf92b8b29f5f3e7b7c99477dffacdb055533b57491f6ec3298ee0dd97abaf"
    sha256 cellar: :any_skip_relocation, catalina:       "99298dc66f2a6a4b12e9f690ff1ab0779e9462926d275740fe94a670de7d26b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7ee2237fbf67c4dc28fd31c990a97e0679cb9251c24b6f96652b1a339353cb5"
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
