class Telegraf < Formula
  desc "Server-level metric gathering agent for InfluxDB"
  homepage "https://www.influxdata.com/"
  url "https://github.com/influxdata/telegraf/archive/v1.20.4.tar.gz"
  sha256 "75b6edbee5084bdf6e8cc216588d17b3e248d141baef5e917036f172099d6732"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55c237fc13ed19f1760333f014f463a7fb1372a49051ea94302ad4d7b8f29bf0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4bcd0c5cd11ba61ed4ee73ed884d4f026ef4b659600fb832e299f711da5324b"
    sha256 cellar: :any_skip_relocation, monterey:       "8e82d87ec5323106dcb1596d973be545ad940028006f9ad81fd717f838093346"
    sha256 cellar: :any_skip_relocation, big_sur:        "09d0bed283ffc66e647027ec0f532ad575f21ea4197d1a825d51653306e47feb"
    sha256 cellar: :any_skip_relocation, catalina:       "8d41a6f1a4dd4411b711e0af072a403a291fdac187bab206fc2bac24bb13a085"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "872f328452ee4d58df51da0bfc68d87201804e5672fcf9f093ac3f34ca2d3b6b"
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
