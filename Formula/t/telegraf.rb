class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/refs/tags/v1.29.5.tar.gz"
  sha256 "ed8ba3117ebf9cc9c96f12d98b1a71fd1c39a7be63fe316391dfffcc3398c30d"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "89e24e7cfb75ff9f86b642f8d9e5b19cb76df28778bd21f77f8fde68ee68815c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7477d7aef5b7055ec8354a85852434ac15e9a12547e3867b8d392dd9071cee51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42774ba1755ceaad96eb147519f5d6e0299530fd42f339f4f58f7d40cfef6407"
    sha256 cellar: :any_skip_relocation, sonoma:         "b8dbbe28b1b801cb0859e34ad39a7d71ba014726eace253eb175b6969c785358"
    sha256 cellar: :any_skip_relocation, ventura:        "ab960689347d140e33772b9b989bd9ed6e02b81f97323fda9a4db95b38ef5dad"
    sha256 cellar: :any_skip_relocation, monterey:       "2293e283b947314317e7959fd86dd65add1ba23ddb2f7899c95c2bcdecac71a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc76fcfe3469c46fb911b9a34a25a81ffc566f4316603b869578c13be82a9b1b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/influxdata/telegraf/internal.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/telegraf"
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
