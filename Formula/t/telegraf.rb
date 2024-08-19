class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/refs/tags/v1.31.3.tar.gz"
  sha256 "2c96ae79b136d6f1dfe2571f262192a68c12aa20796061ce71120a6253e6a524"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c04979f2b0efeec374cd5138fe816f6e5d41f1736075b67df4060877ec0dfd16"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af809513041776af166106435bc9e760fd84bf52c214ef5c4f2e84dd52d466d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65e4bde1e067b0273a576a23b5d942de5a299a4b08c0ee99b39dd806574d9c91"
    sha256 cellar: :any_skip_relocation, sonoma:         "e934eb281cea51e72157b362f9c27534f1247a291b47812fb7eac2497ba3d002"
    sha256 cellar: :any_skip_relocation, ventura:        "dedb034d96917aa09b8058162d9fd57318f7039cbfa9910c3147c51db2f380e5"
    sha256 cellar: :any_skip_relocation, monterey:       "e51dbf7ce9534c076544794d489bf32afe3fa2d2994c95e2c79c643fd1bda890"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21f8b16fe52cb3e5981b9d1e45d6d80e5805fde713eb6eb4fccabf0138a5c7f9"
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
