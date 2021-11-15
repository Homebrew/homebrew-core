class Yaws < Formula
  desc "Webserver for dynamic content (written in Erlang)"
  homepage "http://yaws.hyber.org"
  url "https://github.com/erlyaws/yaws/archive/yaws-2.0.9.tar.gz"
  sha256 "a2bbfe10c780ef2c3b238eaf76d902f4921c63b49d135bb9878b163ef1870a6d"
  license "BSD-3-Clause"
  head "https://github.com/erlyaws/yaws.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/yaws[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "adb085c84a3b06e605da1dfac3864ccb5831327d3c5f39e7413588a32ab106f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55f35e91696552c9e0240835f8fc02c733b2bd657733c86123ee3d472ef5e9f6"
    sha256 cellar: :any_skip_relocation, monterey:       "e9ad8bff29da32d63e13dfc6a97b0728f8ab2ef1e483d7ca8f21a7b682478730"
    sha256 cellar: :any_skip_relocation, big_sur:        "79fe292028db08b81a2f66f80cbc2fd7c52e9801692c416ea275663c61dd4533"
    sha256 cellar: :any_skip_relocation, catalina:       "99c7e7a4fb01e682a1f1cf513ac6b4202f9f030fea64836a0b71354802fde033"
    sha256 cellar: :any_skip_relocation, mojave:         "f8b43c32a42426bc2e0b774e8abde8c7b32206ad19c230231ba22f32a1312eb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30dbc3c5951396f785b714bcf486d0247d399ecae66903a7e3a1872b3165d01f"
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
