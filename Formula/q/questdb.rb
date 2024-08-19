class Questdb < Formula
  desc "Time Series Database"
  homepage "https://questdb.io"
  url "https://github.com/questdb/questdb/releases/download/8.1.0/questdb-8.1.0-no-jre-bin.tar.gz"
  sha256 "9aa7cbf9ba120b192d613f294ead798bc6c92f8f19c4a9a6d7282d04886cd308"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8225dbc461417c9199e96bb08c0666be61805b7ec3b34c6b86b21b3f17758a41"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8225dbc461417c9199e96bb08c0666be61805b7ec3b34c6b86b21b3f17758a41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8225dbc461417c9199e96bb08c0666be61805b7ec3b34c6b86b21b3f17758a41"
    sha256 cellar: :any_skip_relocation, sonoma:         "8225dbc461417c9199e96bb08c0666be61805b7ec3b34c6b86b21b3f17758a41"
    sha256 cellar: :any_skip_relocation, ventura:        "8225dbc461417c9199e96bb08c0666be61805b7ec3b34c6b86b21b3f17758a41"
    sha256 cellar: :any_skip_relocation, monterey:       "8225dbc461417c9199e96bb08c0666be61805b7ec3b34c6b86b21b3f17758a41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e954ecc2c804e5504fc95050336a86af94639fe8164b4cf221e49d23a5be1a6"
  end

  depends_on "openjdk"

  def install
    rm_r("questdb.exe")
    libexec.install Dir["*"]
    (bin/"questdb").write_env_script libexec/"questdb.sh", Language::Java.overridable_java_home_env
    inreplace libexec/"questdb.sh", "/usr/local/var/questdb", var/"questdb"
  end

  def post_install
    # Make sure the var/questdb directory exists
    (var/"questdb").mkpath
  end

  service do
    run [opt_bin/"questdb", "start", "-d", var/"questdb", "-n", "-f"]
    keep_alive successful_exit: false
    error_log_path var/"log/questdb.log"
    log_path var/"log/questdb.log"
    working_dir var/"questdb"
  end

  test do
    # questdb.sh uses `ps | grep` to verify server is running, but output is truncated to COLUMNS
    # See https://github.com/Homebrew/homebrew-core/pull/133887#issuecomment-1679907729
    ENV.delete "COLUMNS" if OS.linux?

    mkdir_p testpath/"data"
    begin
      fork do
        exec bin/"questdb", "start", "-d", testpath/"data"
      end
      sleep 30
      output = shell_output("curl -Is localhost:9000/index.html")
      sleep 4
      assert_match "questDB", output
    ensure
      system bin/"questdb", "stop"
    end
  end
end
