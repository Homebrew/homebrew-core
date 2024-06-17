class Questdb < Formula
  desc "Time Series Database"
  homepage "https://questdb.io"
  url "https://github.com/questdb/questdb/releases/download/8.0.0/questdb-8.0.0-no-jre-bin.tar.gz"
  sha256 "72f7da71d30f6ffc3f9ae68a5e6e9240c0092d28f13fe0fdfd89a982c600604c"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a471b962bb7d44c19b170abdd32b7a5f1e2e6483fef0195f74fc8217ac63773c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a471b962bb7d44c19b170abdd32b7a5f1e2e6483fef0195f74fc8217ac63773c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a471b962bb7d44c19b170abdd32b7a5f1e2e6483fef0195f74fc8217ac63773c"
    sha256 cellar: :any_skip_relocation, sonoma:         "a15cb2b3e5e05f0712e6232ff183e7cf2fe4dd8207b3c77197e44b7999c256f3"
    sha256 cellar: :any_skip_relocation, ventura:        "a15cb2b3e5e05f0712e6232ff183e7cf2fe4dd8207b3c77197e44b7999c256f3"
    sha256 cellar: :any_skip_relocation, monterey:       "a15cb2b3e5e05f0712e6232ff183e7cf2fe4dd8207b3c77197e44b7999c256f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02681dfe0b53b86ac7df7f938463ac5e620d2ff318d4b248b944598b234dd314"
  end

  depends_on "openjdk"

  def install
    rm_rf "questdb.exe"
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
