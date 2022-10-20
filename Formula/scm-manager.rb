class ScmManager < Formula
  desc "Manage Git, Mercurial, and Subversion repos over HTTP"
  homepage "https://www.scm-manager.org"
  url "https://packages.scm-manager.org/repository/releases/sonia/scm/packaging/unix/2.39.0/unix-2.39.0.tar.gz"
  sha256 "8861aa4c765dfe046264f97347065c9c1c6055c14abf4b8d09a340f393a41b29"
  license all_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, all: "130940defae1b8b956c58d3ad23d4a584940cf84a43093b904e668ea5ded775f"
  end

  depends_on "jsvc"
  depends_on "openjdk"

  def install
    # Replace pre-built `jsvc` with formula to add Apple Silicon support
    inreplace "bin/scm-server", %r{ \$BASEDIR/libexec/jsvc-.*"}, " #{Formula["jsvc"].opt_bin}/jsvc\""
    rm Dir["libexec/jsvc-*"]
    libexec.install Dir["*"]

    env = Language::Java.overridable_java_home_env
    env["BASEDIR"] = libexec
    env["REPO"] = libexec/"lib"
    (bin/"scm-server").write_env_script libexec/"bin/scm-server", env
  end

  service do
    run [opt_bin/"scm-server"]
  end

  test do
    port = free_port
    cp_r (libexec/"conf").children, testpath
    inreplace testpath/"server-config.xml" do |s|
      s.gsub! %r{<SystemProperty .*/>/work}, testpath/"work"
      s.gsub! "default=\"8080\"", "default=\"#{port}\""
    end
    ENV["JETTY_BASE"] = testpath
    pid = fork { exec bin/"scm-server" }
    sleep 30
    assert_match "<title>SCM-Manager</title>", shell_output("curl http://localhost:#{port}/scm/")
  ensure
    Process.kill "TERM", pid
  end
end
