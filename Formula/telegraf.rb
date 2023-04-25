class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/refs/tags/v1.26.2.tar.gz"
  sha256 "9759cd834a7ed96c81d67dd9859ae0db9fa3b762e8c8b8f873efd610f77ff76d"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cfc578dad6232fbed8fa71ba18128bf08a99b73ca46204b2feb431f564b3a9a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9ca03add07a35b79b8f077c2969b6f3bac9642c1e634e92d73baa8d0ea5edbe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d084d0b24fe955c15c84fd6e7c41abb96e750f99886fad3761de5889928ae11"
    sha256 cellar: :any_skip_relocation, ventura:        "516d7ccb3ab55510627aefcd1467cf39adf429f599cf042f91b7bc9c5c4c148b"
    sha256 cellar: :any_skip_relocation, monterey:       "0a29f3604e18b11ab042f65451014049e8710000868bbd44753be292a6306b7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f363c8c36a3b2ac05c2db7301bbcf0771c528bc9790d7e23051d78cc936189f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b67d1d340acd3c367f16503ce1d10ec758edc6ec57ddae2eeb73b2908674498"
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
