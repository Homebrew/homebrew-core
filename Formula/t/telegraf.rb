class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/refs/tags/v1.35.2.tar.gz"
  sha256 "545cf4bcd1fcb9b94896c3b107c27550fd0849c12dafa3fbe4b1ca2f96287793"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc67c0f7b517ba00e4f6522bd48f33e0c236d4464485c706ce16a6940dbb49ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1a43ffd9de81014c63fd683719289517b3f45166752a8c479759712fa8599d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "827ac23453654e2341b268af28f6299b70434e61726a8a0688d3e66e08ccb7c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6213fd76b2a3eaef6c08cd0977997db06007cd1b30cfd08f8791f54bb80bdd8"
    sha256 cellar: :any_skip_relocation, ventura:       "a219473ae700fdfae141a82cc62083b845541f81861922973f1bd2fd2e1ad234"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48fa23dc04b6d59d12e1ffc1e5c3475328caacbd4b1017dcb422a3e274fa7ac0"
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
