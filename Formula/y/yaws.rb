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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1a1fbc355b338fa7065c584443271e285bb58a97f06f6ecee0d56463f8ae49c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f466561d44b576cba8fe45a1005e3ca5cd145c56847b412ee7dfc469941247a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a98edfa26642f6927f31550e15dc17998536e6642487794f9a8dac03dcdfb5e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1215945f0993a225b510eec874c9e9422977fadab87ccd69c9f00964145bd31"
    sha256 cellar: :any_skip_relocation, sonoma:         "78f9aeed03048a8ee5694bb72eeaf63722051ba849262b692f9a280202f4cb7d"
    sha256 cellar: :any_skip_relocation, ventura:        "46107a726d6a380084466ba19a082db129dc5deee526ac9a0801240e4385bb33"
    sha256 cellar: :any_skip_relocation, monterey:       "f9a6516efc7a805c785d2a2080dce0bf4c2fc7df5ee7650433d50d97c94acf55"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "645fba5f0f938d597c54f3341742e6e7f62c56e88b39be42456038625fef62bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf623679c1cb98ce64347d7cd92cb3ebcbfd01c16a149632581da989d112cd26"
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
    spawn bin/"yaws", "-c", testpath/"yaws.conf", "--erlarg", "-noshell"
    sleep 6

    output = shell_output("curl --silent localhost:#{port}/example.txt")
    assert_match "401 authentication needed", output

    output = shell_output("curl --user #{user}:#{password} --silent localhost:#{port}/example.txt")
    assert_equal "Hello World!\n", output
  end
end
