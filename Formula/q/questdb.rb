class Questdb < Formula
  desc "Time Series Database"
  homepage "https://questdb.io"
  url "https://github.com/questdb/questdb/releases/download/10.0.1/questdb-10.0.1-no-jre-bin.tar.gz"
  sha256 "049f9421e583c106892e8c7d48b6eaaaf7c24b7c4177fdcc622ebd619a36b032"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "db1c01a4a59ce29f0558925edec43754fbf59ea1278b66ab14c5fbcc06210b0a"
  end

  depends_on "openjdk"

  def install
    rm_r("questdb.exe")
    libexec.install Dir["*"]
    (bin/"questdb").write_env_script libexec/"questdb.sh", Language::Java.overridable_java_home_env
    inreplace libexec/"questdb.sh", "/usr/local/var/questdb", var/"questdb"

    # Make sure the var/questdb directory exists
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
