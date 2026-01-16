class SolrAT811 < Formula
  desc "Enterprise search platform from the Apache Lucene project"
  homepage "https://solr.apache.org/"
  url "https://dlcdn.apache.org/lucene/solr/8.11.4/solr-8.11.4.tgz"
  mirror "https://archive.apache.org/dist/lucene/solr/8.11.4/solr-8.11.4.tgz"
  sha256 "163fbdf246bbd78910bc36c3257ad50cdf31ccc3329a5ef885c23c9ef69e0ebe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "65d79494d324de0e00931020fc1e1624c7929566a4d66cee0b33052111f6e523"
  end

  keg_only :versioned_formula

  # Solr 8 reached end of life (EOL) on 2024-10-25:
  # https://solr.apache.org/news.html#solr-8-reaches-end-of-life
  deprecate! date: "2025-11-07", because: :unsupported

  depends_on "openjdk"

  def install
    pkgshare.install "bin/solr.in.sh"
    (var/"lib/solr").install "server/solr/README.txt", "server/solr/solr.xml", "server/solr/zoo.cfg"
    prefix.install "contrib", "dist", "licenses", "server"
    bin.install "bin/solr", "bin/post", "bin/oom_solr.sh"

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
    # Test fails in docker, see https://github.com/apache/solr/pull/250
    # Newset solr version has been fixed, this legacy version will not be patched,
    # so just ignore the test.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    ENV["SOLR_PID_DIR"] = testpath

    # Info detects no Solr node => exit code 3
    assert_match "No Solr nodes are running", shell_output("#{bin}/solr status", 3)
  end
end
