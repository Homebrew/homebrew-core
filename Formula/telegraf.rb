class Telegraf < Formula
  desc "Server-level metric gathering agent for InfluxDB"
  homepage "https://www.influxdata.com/"
  url "https://github.com/influxdata/telegraf/archive/v1.20.0.tar.gz"
  sha256 "efb577f4f5985a6a0acb36df140527120e7442468bcb24dd63755631f6e8ae1e"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fbe8027619b8821dda7007e1e142485f00c516ffbb777901b4fd92b725727ab2"
    sha256 cellar: :any_skip_relocation, big_sur:       "f70179469099c1e897f6a37c3e9f7dd4afc171bda83dd5ad38fa146ee51fdf1f"
    sha256 cellar: :any_skip_relocation, catalina:      "1dc17b55810b65f53e7e98d66632443b3c23b93cb8760994686b10b53cf2f9b5"
    sha256 cellar: :any_skip_relocation, mojave:        "c0ac9fc56c675f1959c96e9a24b021a6dd890effca6cfba8252da5dee60976a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f650386bdf827de8bd193105e3b7b58be6fcccd1e1f4f24e360e4e69679489ab"
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
