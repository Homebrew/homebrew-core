class Telegraf < Formula
  desc "Server-level metric gathering agent for InfluxDB"
  homepage "https://www.influxdata.com/"
  url "https://github.com/influxdata/telegraf/archive/v1.21.3.tar.gz"
  sha256 "c117b930e82969080204382a2aa9df8572d05b18cfa0caf0ff62cb840af5ce71"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ba70d9f1329d16986424b7f841ce35be02f7b7347a4f1b863965bbc02864454"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6480e15b3ec2862b18d7f1d4c10acccdee47ebbd6b6c27c7b5823d6f88ab12de"
    sha256 cellar: :any_skip_relocation, monterey:       "d7a078caab5ef628f2a7350f19f16965db21c8694d22d2d1f9afbce96eccca82"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a92999e3bb3dd6c725a3d13f6d80675839728396ffa81589e89f75a5e8a1938"
    sha256 cellar: :any_skip_relocation, catalina:       "cfc93581868563ed696bf62cf441bb3309472a4d4e812c1eb27daf51ef5bcea6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af91741e46b41221cdfe80448a863ec31c354f16cc49898c73b188155820c25b"
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
