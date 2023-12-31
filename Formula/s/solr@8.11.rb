class SolrAT811 < Formula
  desc "Enterprise search platform from the Apache Lucene project"
  homepage "https://solr.apache.org/"
  url "https://dlcdn.apache.org/lucene/solr/8.11.2/solr-8.11.2.tgz"
  sha256 "54d6ebd392942f0798a60d50a910e26794b2c344ee97c2d9b50e678a7066d3a6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "430113d21cb3e006e400a60001b5e020cd502aa4d0381f7db437bb9a68f45568"
  end

  keg_only :versioned_formula

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
