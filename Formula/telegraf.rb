class Telegraf < Formula
  desc "Server-level metric gathering agent for InfluxDB"
  homepage "https://www.influxdata.com/"
  url "https://github.com/influxdata/telegraf/archive/v1.24.2.tar.gz"
  sha256 "e0b4bc65dc46a87b14a164c1226f6cee15fabfff14f355344bede3ef3e585925"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cdf019234ad25435e2560c10dc51885c4dbc8a1d57836e399ab0be4e8be3d318"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f112c37dfb1bb76f4ec1bce4fad376b394294eb7a76c8714bd3775c93ea70d2"
    sha256 cellar: :any_skip_relocation, monterey:       "3b72e377895979e675decfec72132164ca8214cff1c3cba6f28c1619c398db1f"
    sha256 cellar: :any_skip_relocation, big_sur:        "33edec2576d612d36d3aa358d56b49e01b650d36456bccd72a09aec2fedbf078"
    sha256 cellar: :any_skip_relocation, catalina:       "afda37fd13202a35c608c405f5eb636215cc2a31f57ec204917e45aa3f6b6e20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21e084ba0ac37a33ef7dddf95b3aad5ea6656a509123a9d2a8bda814d6bf5fb3"
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
