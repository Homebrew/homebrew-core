class Solr < Formula
  desc "Enterprise search platform from the Apache Lucene project"
  homepage "https://solr.apache.org/"
  url "https://dlcdn.apache.org/solr/solr/9.4.0/solr-9.4.0.tgz"
  mirror "https://archive.apache.org/dist/solr/solr/9.4.0/solr-9.4.0.tgz"
  sha256 "5ff28fe3a9d92804d53c0072a8459bb1d0c280e212a288a9efd31f923fe1a9d4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f27ba1ed5a9d2793330d32c546c51bf1e2e942ec90e7275779cb7694e7496a75"
  end

  depends_on "openjdk"

  def install
    pkgshare.install "bin/solr.in.sh"
    (var/"lib/solr").install "server/solr/README.md", "server/solr/solr.xml", "server/solr/zoo.cfg"
    prefix.install "licenses", "modules", "server"
    bin.install "bin/solr", "bin/post"

    env = Language::Java.overridable_java_home_env
    env["SOLR_HOME"] = "${SOLR_HOME:-#{var}/lib/solr}"
    env["SOLR_LOGS_DIR"] = "${SOLR_LOGS_DIR:-#{var}/log/solr}"
    env["SOLR_PID_DIR"] = "${SOLR_PID_DIR:-#{var}/run/solr}"
    bin.env_script_all_files libexec, env

    inreplace libexec/"solr", "/usr/local/share/solr", pkgshare
  end

  def post_install
    (var/"run/solr").mkpath
    (var/"log/solr").mkpath
  end

  service do
    run [opt_bin/"solr", "start", "-f", "-s", HOMEBREW_PREFIX/"var/lib/solr"]
    working_dir HOMEBREW_PREFIX
  end

  test do
    ENV["SOLR_PID_DIR"] = testpath
    port = free_port

    assert_match "No Solr nodes are running", shell_output("#{bin}/solr status")

    # Start a Solr node => exit code 0
    shell_output("#{bin}/solr start -p #{port} -Djava.io.tmpdir=/tmp")
    assert_match "Found 1 Solr nodes", shell_output("#{bin}/solr status")

    # Impossible to start a second Solr node on the same port => exit code 1
    shell_output("#{bin}/solr start -p #{port}", 1)
    # Stop a Solr node => exit code 0
    # Exit code is 1 without init process in a docker container
    shell_output("#{bin}/solr stop -p #{port}", (OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]) ? 1 : 0)
    # No Solr node left to stop => exit code 1
    shell_output("#{bin}/solr stop -p #{port}", 1)
  end
end
