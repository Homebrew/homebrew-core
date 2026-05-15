class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/refs/tags/v1.38.4.tar.gz"
  sha256 "97453df83892bcc987064cc093277881ffeb13bb7c9c9e351c8605b769f84d4f"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "829b98ae07fb02c10e8f1771597c48b023b6858f7dec56371ce16bbce24d8fcc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "daa08cc0481de040f17a758257308e15b1becc47131fa118600ec2ea3d408baa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "377ce56949dbbe3a111154df7c0faecc3a6c41c16ffe8f6f7bdb5a910ba24cd3"
    sha256 cellar: :any_skip_relocation, sonoma:        "f666d8cbec7cff189f5fb19dd969df026410959b355168059f8b359453fa7770"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "276e8cd06161fdffb8a0539c7ecb60ff869858c92fdb31b009a8d03c1abb9139"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc2c34b5e6f30e0dd03f682ab3b64679bc63ce1041be2a203d19a8bc1423bf6f"
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
