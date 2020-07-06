class Yaws < Formula
  desc "Webserver for dynamic content (written in Erlang)"
  homepage "http://yaws.hyber.org"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/erlyaws/yaws.git"

  stable do
    url "https://github.com/erlyaws/yaws/archive/yaws-2.0.7.tar.gz"
    sha256 "083b1b6be581fdfb66d77a151bbb2fc3897b1b0497352ff6c93c2256ef2b08f6"

    # Erlang 23 compatibility
    # Remove with the next release. Also remove `WARNINGS_AS_ERRORS=` flag from `make install` call
    patch do
      url "https://github.com/erlyaws/yaws/compare/c0fd79f17d52628fcec527da7fa3e788c283c445..28eecfd1c65c369de5b4b99cea9407205bbe8f8e.patch?full_index=1"
      sha256 "0dbcb92e961ae9dc9d6613436f5d39e0c1b675635cfbeef888e1d2b487add413"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "09997293c21d6a547bd35e3c6384eae48376665729e02e9008d3fe59e2436c4d" => :catalina
    sha256 "bb522ea70a11984cb30b10ad4a0fe6a8140d4a6b55916ded173fb44732d185e4" => :mojave
    sha256 "627c282c11101b0f7b036e52ddff6e33db668540bb8c94a7ba9e45ab510f46f4" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "erlang"

  # the default config expects these folders to exist
  skip_clean "var/log/yaws"
  skip_clean "lib/yaws/examples/ebin"
  skip_clean "lib/yaws/examples/include"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--prefix=#{prefix}",
                          # Ensure pam headers are found on Xcode-only installs
                          "--with-extrainclude=#{MacOS.sdk_path}/usr/include/security",
                          "SED=/usr/bin/sed"
    system "make", "install", "WARNINGS_AS_ERRORS="

    cd "applications/yapp" do
      system "make"
      system "make", "install"
    end

    # the default config expects these folders to exist
    (lib/"yaws/examples/ebin").mkpath
    (lib/"yaws/examples/include").mkpath
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
