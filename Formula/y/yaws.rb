class Yaws < Formula
  desc "Webserver for dynamic content (written in Erlang)"
  homepage "http://yaws.hyber.org"
  url "https://github.com/erlyaws/yaws/archive/refs/tags/yaws-2.1.1.tar.gz"
  sha256 "aeb74f0051fe9a2925b1a1b4f13af31ec5404acfbe000ac32cda25ee9779f4bf"
  license "BSD-3-Clause"
  head "https://github.com/erlyaws/yaws.git", branch: "master"

  livecheck do
    url :stable
    regex(/yaws[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9691b1f2db8123fa575ffeec832355aa28fc3206796dfe743509528e364ff859"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "979fa10690f71f32f99ff48ba73b61db66841fc6dab8759a0b70d768d4e09483"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "915f2debcd29895c2dd235232fae27c6b93a8df74600324fc6281c037a8f0a9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9e8b1c12a01f2a69f60629ce7e9238b502cefca4838c7ec8f10add24560c66a"
    sha256 cellar: :any_skip_relocation, sonoma:         "2eb08889b5aec7d6e7cdabf8b5deda6ba98ed696ecea94dc9474908067b48c2e"
    sha256 cellar: :any_skip_relocation, ventura:        "32023b27f056a704bf8a74a83cd07efc1680b440ff6b7f2e22c3549d38e221ac"
    sha256 cellar: :any_skip_relocation, monterey:       "c8ed14ebe8b7754b382567af80237d9622197e3a10b1aa673aaf6201c9d8cc17"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8ed6901333af5bda880682772f53eb3cbcfc89323527d0820696e9a0d963979"
    sha256 cellar: :any_skip_relocation, catalina:       "1c84e7ed9b5329b5d79eeed7fabcf63bac90ae398481b1d71104ee97958056df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a98f436c58c2cc58eebfaf052387faf4c02f9554138935f674d6b6dd5cb8df94"
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
    extra_args = if OS.mac?
      # Ensure pam headers are found on Xcode-only installs
      %W[
        --with-extrainclude=#{MacOS.sdk_path}/usr/include/security
      ]
    else
      %W[
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
