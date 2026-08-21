class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/refs/tags/v1.39.3.tar.gz"
  sha256 "13b4186fac9a9d29858c532b73efc41e0a1ac8ce93a615b59d5a6e589e71ab2f"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "671843fb120e3426c119f621b4dc3adb261cf82071ebea36e7934c206c8fdc59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b4ad063600a26f0b643e5b2673e9e111ba9dc77e154ad7c4db032f46cf80f5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88b79a1bd4b03f986e3f6b35af0f319c657f9a580eca9df0b06342f4faeca674"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1139a1b3a520fee1c9b41fb5777e3b28f11fe3ed8e31d05f7a6ea9f4a6d903d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4d1ff6d2c3fa2e07afb7b4eea567d34781625ad4bccbd3db014ade2ff7950bb"
    sha256 cellar: :any,                 x86_64_linux:  "6543a2e48d8ae74732450f55622b92dbd06a5f33151dfd0b14a25d45ff7717c7"
  end

  depends_on "go" => :build

  def install
    build_version = build.head? ? "0.0.0-#{version}" : version
    ldflags = "-X github.com/influxdata/telegraf/internal.Version=#{build_version}"
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
