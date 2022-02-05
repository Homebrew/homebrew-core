class Yaws < Formula
  desc "Webserver for dynamic content (written in Erlang)"
  homepage "http://yaws.hyber.org"
  url "https://github.com/erlyaws/yaws/archive/yaws-2.1.1.tar.gz"
  sha256 "aeb74f0051fe9a2925b1a1b4f13af31ec5404acfbe000ac32cda25ee9779f4bf"
  license "BSD-3-Clause"
  head "https://github.com/erlyaws/yaws.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/yaws[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "205fe2606652bae200a7754f6e8ec2ed1b7865cb922bd5ed8286090cd6f19c48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94daf2c5984d8a05d7d3c60479c4e860d23b2e26786ba3369c83550372e11ed7"
    sha256 cellar: :any_skip_relocation, monterey:       "3aa12271c6014bee14f1a6a0535ef908c69bc5104bcfef8dfd851881288a0d7f"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b5e7e193142227692ef73cde396b76bb2431041243d57d07717ca4caacbf257"
    sha256 cellar: :any_skip_relocation, catalina:       "d3dc8a6301bcda2d105d3250b15a79bf4e3fa93d0797644f6ec3f20ddff23574"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37b39e3db26a112b141461520a0b9986e76f69c2d2a0125718ce0e84ef905c59"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "erlang"

  on_linux do
    depends_on "linux-pam"
  end

  # the default config expects these folders to exist
  skip_clean "var/log/yaws"
  skip_clean "lib/yaws/examples/ebin"
  skip_clean "lib/yaws/examples/include"

  def install
    # Ensure pam headers are found on Xcode-only installs
    extra_args = %W[
      --with-extrainclude=#{MacOS.sdk_path}/usr/include/security
    ]
    if OS.linux?
      extra_args = %W[
        --with-extrainclude=#{Formula["linux-pam"].opt_include}/security
      ]
    end
    system "autoreconf", "-fvi"
    system "./configure", "--prefix=#{prefix}", *extra_args
    system "make", "install", "WARNINGS_AS_ERRORS="

    cd "applications/yapp" do
      system "make"
      system "make", "install"
    end

    # the default config expects these folders to exist
    (lib/"yaws/examples/ebin").mkpath
    (lib/"yaws/examples/include").mkpath

    # Remove Homebrew shims references on Linux
    inreplace Dir["#{prefix}/var/yaws/www/*/Makefile"], Superenv.shims_path, "/usr/bin" if OS.linux?
  end

  def post_install
    (var/"log/yaws").mkpath
    (var/"yaws/www").mkpath
  end

  test do
    user = "user"
    password = "password"
    port = free_port

    (testpath/"www/example.txt").write <<~EOS
      Hello World!
    EOS

    (testpath/"yaws.conf").write <<~EOS
      logdir = #{mkdir(testpath/"log").first}
      ebin_dir = #{mkdir(testpath/"ebin").first}
      include_dir = #{mkdir(testpath/"include").first}

      <server localhost>
        port = #{port}
        listen = 127.0.0.1
        docroot = #{testpath}/www
        <auth>
                realm = foobar
                dir = /
                user = #{user}:#{password}
        </auth>
      </server>
    EOS
    fork do
      exec bin/"yaws", "-c", testpath/"yaws.conf", "--erlarg", "-noshell"
    end
    sleep 3

    output = shell_output("curl --silent localhost:#{port}/example.txt")
    assert_match "401 authentication needed", output

    output = shell_output("curl --user #{user}:#{password} --silent localhost:#{port}/example.txt")
    assert_equal "Hello World!\n", output
  end
end
