class Solr < Formula
  desc "Enterprise search platform from the Apache Lucene project"
  homepage "https://solr.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=solr/solr/10.1.0/solr-10.1.0.tgz"
  mirror "https://archive.apache.org/dist/solr/solr/10.1.0/solr-10.1.0.tgz"
  sha256 "67c2303404fbce6ca12e82b1f88bde74359b0068a0c882b1046dfb06f9671c38"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0c18cb7b04322b6468d1859e53c1ab38a0fb7bf8a8799b6cd5714aa36335e978"
  end

  # Can be updated after https://github.com/apache/solr/pull/3153
  depends_on "openjdk@21"

  def install
    pkgshare.install "bin/solr.in.sh"
    (var/"lib/solr").install "server/solr/README.md", "server/solr/solr.xml", "server/solr/zoo.cfg"
    (var/"log/solr").mkpath
    (var/"run/solr").mkpath
    prefix.install "licenses", "modules", "server"
    bin.install "bin/solr"

    env = Language::Java.overridable_java_home_env("21")
    env["SOLR_HOME"] = "${SOLR_HOME:-#{var}/lib/solr}"
    env["SOLR_LOGS_DIR"] = "${SOLR_LOGS_DIR:-#{var}/log/solr}"
    env["SOLR_PID_DIR"] = "${SOLR_PID_DIR:-#{var}/run/solr}"
    bin.env_script_all_files libexec, env

    inreplace libexec/"solr", "/usr/local/share/solr", pkgshare
  end

  service do
    run [opt_bin/"solr", "start", "-f", "--user-managed", "--solr-home", HOMEBREW_PREFIX/"var/lib/solr"]
    working_dir HOMEBREW_PREFIX
  end

  test do
    ENV["SOLR_PID_DIR"] = testpath
    port = free_port

    assert_match "No Solr nodes are running", shell_output("#{bin}/solr status")

    # Start a Solr node => exit code 0
    shell_output("#{bin}/solr start --user-managed -p #{port} -Djava.io.tmpdir=/tmp")
    assert_match(/Solr process \d+ running on port #{port}/, shell_output("#{bin}/solr status"))

    # Impossible to start a second Solr node on the same port => exit code 1
    shell_output("#{bin}/solr start --user-managed -p #{port}", 1)
    # Stop a Solr node => exit code 0
    shell_output("#{bin}/solr stop -p #{port}")
    # No Solr node left to stop => exit code 1
    shell_output("#{bin}/solr stop -p #{port}", 1)
  end
end
