class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/refs/tags/v1.26.1.tar.gz"
  sha256 "6896dddd06e0756df54f2678c77e3eea45354b2ae167ccec1de8352f0554b8cb"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22f5f355511b0b978e286318606c8d5561de75c1c16c3f4d9bfe471ccd272887"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e551f2b1a7b7bdde2720436597de54448276194e0fdf25f16e1a20304cee08a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e84c4f3f6d8b936b988800dbf221d88b09a030dd6795d0bcc2eff2d8007daca5"
    sha256 cellar: :any_skip_relocation, ventura:        "f3d5e3915a42a3a9afc5546ca6e892cb7ee0d83701454bd99472c5bd6df4ba81"
    sha256 cellar: :any_skip_relocation, monterey:       "3c213b73711d4b35bdb9b2176abeee772be7806abe1b9f224c80b13e102ab470"
    sha256 cellar: :any_skip_relocation, big_sur:        "322ceb458f74ddd66e12a64a404b83ebe0c21d0efebee186d482edb479679792"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f07c5704fe69e312b4485f1342f3672e921163481c7606c4071b96272e4fa49"
  end

  depends_on "go" => :build

  # Fix an undefined symbol error on Apple Silicon.
  # Remove when `github.com/shoenig/go-m1cpu` v0.1.5 is used by upstream.
  on_macos do
    on_arm do
      patch :DATA
    end
  end

  def install
    ldflags = "-s -w -X github.com/influxdata/telegraf/internal.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/telegraf"
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

__END__
--- a/go.mod
+++ b/go.mod
@@ -388,7 +388,7 @@ require (
 	github.com/rogpeppe/fastuuid v1.2.0 // indirect
 	github.com/russross/blackfriday/v2 v2.1.0 // indirect
 	github.com/samuel/go-zookeeper v0.0.0-20200724154423-2164a8ac840e // indirect
-	github.com/shoenig/go-m1cpu v0.1.4 // indirect
+	github.com/shoenig/go-m1cpu v0.1.5 // indirect
 	github.com/signalfx/com_signalfx_metrics_protobuf v0.0.3 // indirect
 	github.com/signalfx/gohistogram v0.0.0-20160107210732-1ccfd2ff5083 // indirect
 	github.com/signalfx/sapm-proto v0.7.2 // indirect
--- a/go.sum
+++ b/go.sum
@@ -2062,6 +2062,8 @@ github.com/shirou/gopsutil/v3 v3.23.3 h1:Syt5vVZXUDXPEXpIBt5ziWsJ4LdSAAxF4l/xZeQ
 github.com/shirou/gopsutil/v3 v3.23.3/go.mod h1:lSBNN6t3+D6W5e5nXTxc8KIMMVxAcS+6IJlffjRRlMU=
 github.com/shoenig/go-m1cpu v0.1.4 h1:SZPIgRM2sEF9NJy50mRHu9PKGwxyyTTJIWvCtgVbozs=
 github.com/shoenig/go-m1cpu v0.1.4/go.mod h1:Wwvst4LR89UxjeFtLRMrpgRiyY4xPsejnVZym39dbAQ=
+github.com/shoenig/go-m1cpu v0.1.5 h1:LF57Z/Fpb/WdGLjt2HZilNnmZOxg/q2bSKTQhgbrLrQ=
+github.com/shoenig/go-m1cpu v0.1.5/go.mod h1:Wwvst4LR89UxjeFtLRMrpgRiyY4xPsejnVZym39dbAQ=
 github.com/shoenig/test v0.6.3 h1:GVXWJFk9PiOjN0KoJ7VrJGH6uLPnqxR7/fe3HUPfE0c=
 github.com/shoenig/test v0.6.3/go.mod h1:byHiCGXqrVaflBLAMq/srcZIHynQPQgeyvkvXnjqq0k=
 github.com/shopspring/decimal v0.0.0-20180709203117-cd690d0c9e24/go.mod h1:M+9NzErvs504Cn4c5DxATwIqPbtswREoFCre64PpcG4=
