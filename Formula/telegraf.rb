class Telegraf < Formula
  desc "Server-level metric gathering agent for InfluxDB"
  homepage "https://www.influxdata.com/"
  url "https://github.com/influxdata/telegraf/archive/v1.21.2.tar.gz"
  sha256 "2a6c0722c6999c438d316d5971502aa79abd92134c265ee0e53596cc125d175b"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3037aad7b419b51fb01d17b7c5e824427327cd4c25d5edcb09816ae2dba4748d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9bb497017d671fb3eadbb758bcd2a6f5ffd17fd82fe35f220821f93bb6cf5103"
    sha256 cellar: :any_skip_relocation, monterey:       "a5f6be6d27e02e79de7d82f9b0db4de037362c445d5776b5ea130dbcd1b16a09"
    sha256 cellar: :any_skip_relocation, big_sur:        "40ec51cdf19ab6677ef98f71f60bf40fffbb82d7e65df4f1222d05dd51b084e7"
    sha256 cellar: :any_skip_relocation, catalina:       "4a63d307a97f67e076e2f34226e8e4f1c02905c758344279afa81727b82aaaee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de271ab9b4c74d5ff826a85613fc76f4af0a93882f27a7278cd8d6cd012fa5b7"
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
