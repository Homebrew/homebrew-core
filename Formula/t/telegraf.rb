class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/refs/tags/v1.38.1.tar.gz"
  sha256 "ad1cd8da4b1494537911d00e094712fa99612de99713524439a5159842f94c51"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42bb1e321a56f6b4dc9ac8ba732ea5e0171bdf54325a8811f839374979be16a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa89818814abfb04df2f045e8cc94917696267c9244bebdd99116b37379f6ab9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dea1eee41d39068f30cc3103c71bb257dc7a1f681b8fa67f57a0699dccb7933f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4bcdc6b68cf7569c59420b0d5b629a5e111bb241e8102767b03eac7f6beaa34e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6aa623b6a08359b0ee3d2a7bc6058def0b5434724047e02512081efbe7d889b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f34d49d128e80b46d6db09124f3b4587f184e442c9e17c50a22055364bdd8e34"
  end

  depends_on "go" => :build

  def install
    build_version = build.head? ? "0.0.0-#{version}" : version
    ldflags = "-s -w -X github.com/influxdata/telegraf/internal.Version=#{build_version}"
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
