class Yaws < Formula
  desc "Webserver for dynamic content (written in Erlang)"
  homepage "https://erlyaws.github.io/"
  url "https://github.com/erlyaws/yaws/archive/refs/tags/yaws-2.2.0.tar.gz"
  sha256 "39318736472c165d4aec769c89ac4edfe3cab7ff7759f32de0a4e699ef6c88e8"
  license "BSD-3-Clause"
  head "https://github.com/erlyaws/yaws.git", branch: "master"

  livecheck do
    url :stable
    regex(/yaws[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4479efc9ab84cd8f012651d05d28a2ce94dbe56eb3c5bbfba8bed95652dff27a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "845f04a03d4cc7fae790142bbeab2cc65efa0a51e0049e6a616138470089119d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78bf0b4af2d43b0a2bdc77134dc85b9fea30a672b9f19f62f8057a97b708e10a"
    sha256                               sonoma:        "d2d4b74599fa98fdf09ac21cd21112418036dbfa5619cd3871810836b96172f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c69ad4c9bdbcfa150427057eda6fff5827d3b9e1548bc52124dd1a572e0c0c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5585acc49cfeca4dc82ffb280b1ade5a2f8cb6164b801435718b9ee97858c77"
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
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *extra_args, *std_configure_args
    system "make", "install", "WARNINGS_AS_ERRORS="
    system "make", "-C", "applications/yapp", "install"

    # the default config expects these folders to exist
    (lib/"yaws/examples/ebin").mkpath
    (lib/"yaws/examples/include").mkpath

    # Remove Homebrew shims references on Linux
    inreplace prefix.glob("var/yaws/www/*/Makefile"), Superenv.shims_path, "/usr/bin" if OS.linux?

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
    spawn bin/"yaws", "-c", testpath/"yaws.conf", "--erlarg", "-noshell"
    sleep 6

    output = shell_output("curl --silent localhost:#{port}/example.txt")
    assert_match "401 authentication needed", output

    output = shell_output("curl --user #{user}:#{password} --silent localhost:#{port}/example.txt")
    assert_equal "Hello World!\n", output
  end
end
