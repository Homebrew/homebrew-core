class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/refs/tags/v1.38.2.tar.gz"
  sha256 "8f67651b9ff690593b57a8ff7703dbf9764bb1a356433503a4d9a27a69d26321"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9cae292d3a28a8cd38d15a2c887db85b655c9a2c5575d042089788e22ce2c091"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3d2cf2c562a44204d77918d18506d6d8e4df1d4f8664e9be374b0ad4b37fecd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "539716d98b748f65db1017e69bc33798d6451b13ac46e1cf072488e3b7346b38"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7b82dc1f31f03eb41d1fae0a88ee1c2e1152e37e840eda12cf3719cdce82de9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cfe47784a27d9f45daf10f303c7e02a93f6945df36863ca616b02702b45a81d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f590a048a17ba447f3c67c54f6e405d5fa88658f5572a12d7d28af2fdd1a6eb"
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
