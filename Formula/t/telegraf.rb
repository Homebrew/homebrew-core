class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/refs/tags/v1.36.1.tar.gz"
  sha256 "2478f4c9543300ed44cc0a3329e5a4c6095d9a6eae86aa2deab4ff9d19c1fdd5"
  license "MIT"
  revision 1
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc7085a1f975340ba42c482b70272e12c0b1ffab9151bb783ac93ab40ede1035"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17806893a70f7a01b06da23929dd73699aedb2a061a6d30783edb2e6797c506e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbb1f8c8d8214729f30cccebce6bacbcf964d7512557c01ad65e59c0ee077a78"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fc259488b9582bf528370a57eb3bee5688b3c6ff788e92f39186e6ea223f2367"
    sha256 cellar: :any_skip_relocation, sonoma:        "12629bde117747d88418cee4d6123fb39ba95828905196d6e96bfa6827ffa448"
    sha256 cellar: :any_skip_relocation, ventura:       "d3b6348b243a63376fe8e0b884b208be9a000d49abd808316e446ec1623d8870"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bb234f6bd0f8b8de4d424dc96c9fda63caa81c1efd79935aa2f563f86a5840d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/influxdata/telegraf/internal.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/telegraf"

    (buildpath/"telegraf.conf").write Utils.safe_popen_read(bin/"telegraf", "config")
    etc.install "telegraf.conf"
    # Create directory for additional user configurations
    (etc/"telegraf.d").mkpath
  end

  service do
    run [opt_bin/"telegraf", "-config", etc/"telegraf.conf", "-config-directory", etc/"telegraf.d"]
    keep_alive true
    working_dir var
    log_path var/"log/telegraf.log"
    error_log_path var/"log/telegraf.log"
    environment_variables HOME: HOMEBREW_PREFIX
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/telegraf --version")
    (testpath/"config.toml").write shell_output("#{bin}/telegraf -sample-config")
    system bin/"telegraf", "-config", testpath/"config.toml", "-test", "-input-filter", "cpu:mem"
  end
end
