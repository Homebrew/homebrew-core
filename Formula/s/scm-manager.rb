class ScmManager < Formula
  desc "Manage Git, Mercurial, and Subversion repos over HTTP"
  homepage "https://www.scm-manager.org"
  url "https://packages.scm-manager.org/repository/releases/sonia/scm/packaging/unix/2.45.2/unix-2.45.2.tar.gz"
  sha256 "bede37ed7bf2a444643814afee01fc7f5f7c93d2018131dd9a6c95532483b054"
  license all_of: ["Apache-2.0", "MIT"]

  livecheck do
    url "https://scm-manager.org/download/"
    regex(/href=.*?unix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4baa76a1fb3b76f72fdc49b54c8ecbcb36907b94e77df03c63c0fbe4ec786c3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4baa76a1fb3b76f72fdc49b54c8ecbcb36907b94e77df03c63c0fbe4ec786c3a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4baa76a1fb3b76f72fdc49b54c8ecbcb36907b94e77df03c63c0fbe4ec786c3a"
    sha256 cellar: :any_skip_relocation, ventura:        "4baa76a1fb3b76f72fdc49b54c8ecbcb36907b94e77df03c63c0fbe4ec786c3a"
    sha256 cellar: :any_skip_relocation, monterey:       "4baa76a1fb3b76f72fdc49b54c8ecbcb36907b94e77df03c63c0fbe4ec786c3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "4baa76a1fb3b76f72fdc49b54c8ecbcb36907b94e77df03c63c0fbe4ec786c3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aca9714e2bb9d8ffe8d5cf70aabb6c9fb5875e6c9276b781e92bbb301078fe83"
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
