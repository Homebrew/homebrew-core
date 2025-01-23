class ScmManager < Formula
  desc "Manage Git, Mercurial, and Subversion repos over HTTP"
  homepage "https://www.scm-manager.org"
  url "https://packages.scm-manager.org/repository/releases/sonia/scm/packaging/unix/3.6.1/unix-3.6.1.tar.gz"
  sha256 "4f203120d53ed741f2bebc20f2ab808d0849843fa06bd381f95a0f251d719ec6"
  license all_of: ["Apache-2.0", "MIT"]

  livecheck do
    url "https://scm-manager.org/download/"
    regex(/href=.*?unix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d55cedfcb8eccb8e2a53ed7e2231198ecfd424f8f1ba76b7f45375c336c9c195"
  end

  depends_on "jsvc"
  depends_on "openjdk@21"

  def install
    # Replace pre-built `jsvc` with formula to add Apple Silicon support
    inreplace "bin/scm-server", %r{ \$BASEDIR/libexec/jsvc-.*"}, " #{Formula["jsvc"].opt_bin}/jsvc\""
    rm Dir["libexec/jsvc-*"]
    libexec.install Dir["*"]

    env = Language::Java.overridable_java_home_env("21")
    env["BASEDIR"] = libexec
    env["REPO"] = libexec/"lib"
    (bin/"scm-server").write_env_script libexec/"bin/scm-server", env
  end

  service do
    run [opt_bin/"scm-server"]
  end

  test do
    port = free_port

    cp libexec/"conf/config.yml", testpath
    inreplace testpath/"config.yml" do |s|
      s.gsub! "./work", testpath/"work"
      s.gsub! "port: 8080", "port: #{port}"
    end
    ENV["JETTY_BASE"] = testpath
    pid = fork { exec bin/"scm-server" }
    sleep 15
    assert_match "<title>SCM-Manager</title>", shell_output("curl http://localhost:#{port}/scm/")
  ensure
    Process.kill "TERM", pid
  end
end
