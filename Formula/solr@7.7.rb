class SolrAT77 < Formula
  desc "Enterprise search platform from the Apache Lucene project"
  homepage "https://solr.apache.org"
  url "https://dlcdn.apache.org/lucene/solr/7.7.3/solr-7.7.3.tgz"
  mirror "https://archive.apache.org/dist/lucene/solr/7.7.3/solr-7.7.3.tgz"
  sha256 "3ec67fa430afa5b5eb43bb1cd4a659e56ee9f8541e0116d6080c0d783870baee"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "2ece595725317381657387652c053d0e88069f7238c8ce9decbd91794ab5fc7e"
  end

  keg_only :versioned_formula

  # The 7.7 series is end of life (EOL) as of 2022-05.
  deprecate! date: "2022-05-12", because: :unsupported

  depends_on "openjdk@11"

  def install
    pkgshare.install "bin/solr.in.sh"
    (var/"lib/solr").install "server/solr/README.txt", "server/solr/solr.xml", "server/solr/zoo.cfg"
    prefix.install %w[contrib dist server]
    libexec.install "bin"
    bin.install [libexec/"bin/solr", libexec/"bin/post", libexec/"bin/oom_solr.sh"]

    env = Language::Java.overridable_java_home_env("11")
    env["SOLR_HOME"] = "${SOLR_HOME:-#{var/"lib/solr"}}"
    env["SOLR_LOGS_DIR"] = "${SOLR_LOGS_DIR:-#{var/"log/solr"}}"
    env["SOLR_PID_DIR"] = "${SOLR_PID_DIR:-#{var/"run/solr"}}"
    bin.env_script_all_files libexec, env
    (libexec/"bin").rmtree

    inreplace libexec/"solr", "/usr/local/share/solr", pkgshare
  end

  def post_install
    (var/"run/solr").mkpath
    (var/"log/solr").mkpath
  end

  service do
    run [opt_bin/"solr", "start", "-f"]
    working_dir HOMEBREW_PREFIX
  end

  test do
    ENV["SOLR_PID_DIR"] = testpath
    port = free_port

    # Info detects no Solr node => exit code 3
    shell_output(bin/"solr -i", 3)
    # Start a Solr node => exit code 0
    shell_output(bin/"solr start -p #{port} -Djava.io.tmpdir=/tmp")
    # Info detects a Solr node => exit code 0
    shell_output(bin/"solr -i")
    # Impossible to start a second Solr node on the same port => exit code 1
    shell_output(bin/"solr start -p #{port}", 1)

    # Test fails in docker, see https://github.com/apache/solr/pull/250
    # Newset solr version has been fixed, this legacy version will not be patched,
    # so just ignore the test.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    # Stop a Solr node => exit code 0
    shell_output(bin/"solr stop -p #{port}")
    # No Solr node left to stop => exit code 1
    shell_output(bin/"solr stop -p #{port}", 1)
  end
end
