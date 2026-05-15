class Questdb < Formula
  desc "Time Series Database"
  homepage "https://questdb.io"
  url "https://github.com/questdb/questdb/releases/download/9.3.5/questdb-9.3.5-no-jre-bin.tar.gz"
  sha256 "4efca6374df443d93da8f6c1bebb4770e8d3f4a20bc34b730a57b5a5d23b063f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6bd987ae155f50245fda81e06bdf2807c91bfbe1415b2c0955db400f89a18f20"
  end

  depends_on "openjdk"

  def install
    rm_r("questdb.exe")
    libexec.install Dir["*"]
    (bin/"questdb").write_env_script libexec/"questdb.sh", Language::Java.overridable_java_home_env
    inreplace libexec/"questdb.sh", "/usr/local/var/questdb", var/"questdb"

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
      spawn bin/"questdb", "start", "-d", testpath/"data"
      output = shell_output("curl --head --silent --retry 5 --retry-connrefused localhost:9000/index.html")
      assert_match "questDB", output
    ensure
      system bin/"questdb", "stop"
    end
  end
end
