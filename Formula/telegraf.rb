class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/refs/tags/v1.26.3.tar.gz"
  sha256 "42bb0437ffb4110381783f5066ab61fe78ea5c920241e8c3301afcbcdbccb0f9"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a1f69244c06cde0ed69b83f867d5e005304f84c7296d9deb00f482e6efdcfb4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2e5c040b0b321f8e3c19ab2e2f9a1c0973e04a7a2683a73b20dc155b07fc317"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a1c73b055b2e273bfca919dfe4ff8b9089c136aa302adf64909dee74f1692c4"
    sha256 cellar: :any_skip_relocation, ventura:        "72e603fd0f38a5adceb6ef204e9fef11cfd4cfe2b62927b50a09ca56df4d576d"
    sha256 cellar: :any_skip_relocation, monterey:       "237590a2d810d44577b7e22285632750737a8253f30fef61a5b2b06c85816aba"
    sha256 cellar: :any_skip_relocation, big_sur:        "4abd622f03b6bf13e48eb79470283d445b557300a91488343c717b756369e72b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77b2d071451aa32f827431439ff46103fbd36bd2447204cf2731749d1aa6d1da"
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
