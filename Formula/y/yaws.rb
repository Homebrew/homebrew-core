class Yaws < Formula
  desc "Webserver for dynamic content (written in Erlang)"
  homepage "https://erlyaws.github.io/"
  url "https://github.com/erlyaws/yaws/archive/refs/tags/yaws-2.3.1.tar.gz"
  sha256 "a65110377b007693c6ddccdb061a57c6bd5b5bad88b976d75d6213aaabc8f5c5"
  license "BSD-3-Clause"
  head "https://github.com/erlyaws/yaws.git", branch: "master"

  livecheck do
    url :stable
    regex(/yaws[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0629320e62e14c5dbfed5c834bfa166dd1077cd5d0df943ba18d5d721c0b7cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0cb3c87cc60dd5dacb0b6acc9cb7fe99ffd0ab073ec160fd373c91f2be09489d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79a01410336e2eb53d37f2e1af63d0d09430ad29209a42e16e77f7615ee338ca"
    sha256                               sonoma:        "de5689a0f5e8831bf8d79aaaaa02c7c20ef0eeed497c30d21773381235f7d071"
    sha256 cellar: :any,                 arm64_linux:   "0047af968c92cda969bd782b0103eb07c95540cbc379d1be7ac53568294834f6"
    sha256 cellar: :any,                 x86_64_linux:  "5cd1962303c9ed3937fa80bb578ec4cd637cdff756dde2d7235968f885080fd6"
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
    pam_include = OS.mac? ? "#{MacOS.sdk_path}/usr/include" : formula_opt_include("linux-pam")
    args = %W[--with-extrainclude=#{pam_include}/security]

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *args, *std_configure_args
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
