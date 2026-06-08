class Solr < Formula
  desc "Enterprise search platform from the Apache Lucene project"
  homepage "https://solr.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=solr/solr/10.0.0/solr-10.0.0.tgz"
  mirror "https://archive.apache.org/dist/solr/solr/10.0.0/solr-10.0.0.tgz"
  sha256 "07c180970f60d13776be13ccb60c707d041e5e1a8b914d197d1358ac25f804b5"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "5acd947f8767a29eebf0748639ab369d30c981170b8211082d987aab0c351180"
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

    env = Language::Java.overridable_java_home_env
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
    # Exit code is 1 without init process in a docker container
    shell_output("#{bin}/solr stop -p #{port}", (OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]) ? 1 : 0)
    # No Solr node left to stop => exit code 1
    shell_output("#{bin}/solr stop -p #{port}", 1)
  end
end
