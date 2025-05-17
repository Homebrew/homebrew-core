class Redex < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Bytecode optimizer for Android apps"
  homepage "https://fbredex.com/"
  url "https://github.com/facebook/redex/archive/refs/tags/v2025.03.31.tar.gz"
  sha256 "39f43b887bd55b1910de65159960da8ff126d4918c2a3c785e70ddc5ffec148d"
  license "MIT"
  head "https://github.com/facebook/redex.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "65347da8f446206921fbb0603b12153dacc92e1eaa161b1b74ebb38576d5ac3c"
    sha256 cellar: :any,                 arm64_sonoma:  "b658660c4464c283aa5cdf0605713ef2dfc3175a2d1fe3b57469596f784eb2c0"
    sha256 cellar: :any,                 arm64_ventura: "055c56e57ce9c88ab726e404aeb3340c4362019441d4f1452a492d2137e123db"
    sha256 cellar: :any,                 sonoma:        "dd78be4ea12bac4c61703901214dd005b018d01b281c0ab165a1ff037fd68c39"
    sha256 cellar: :any,                 ventura:       "1a3bd9ed872f59a6d1c3ec85b594f3b35efd486aea558aabff2187e10e8dba05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9eaa938b67836b3dd1dffa66155ab941af8a7f934b96e3ec6966956fb2e46030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96e5068164b73fadae8977be7a224314b14f9146c7dad18f911e9ee041a58259"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libevent" => :build
  depends_on "libtool" => :build
  depends_on "boost"
  depends_on "jsoncpp"
  depends_on "python@3.13"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  # Replace `distutils` with `packaging` for python 3.12+
  patch do
    url "https://github.com/facebook/redex/commit/aecf5d7e595ed1ece7cabc16e974280b97ca7efc.patch?full_index=1"
    sha256 "3ae2e72634d33bb3d2b7668b7ce864adbbcca053f15b83b383ec505e304e8553"
  end

  def install
    # Skip tests, which require an Android SDK
    inreplace "Makefile.am", "SUBDIRS = . test", "SUBDIRS = ."
    # Replace `pipes` usage for python 3.13
    inreplace "redex.py", "from pipes import quote", "from shlex import quote"

    venv = virtualenv_create(libexec, "python3.13")
    venv.pip_install resources
    rewrite_shebang python_shebang_rewrite_info(venv.root/"bin/python"), "redex.py"

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules",
                          "--with-boost=#{Formula["boost"].opt_prefix}",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    resource "homebrew-test_apk" do
      url "https://raw.githubusercontent.com/facebook/redex/fa32d542d4074dbd485584413d69ea0c9c3cbc98/test/instr/redex-test.apk"
      sha256 "7851cf2a15230ea6ff076639c2273bc4ca4c3d81917d2e13c05edcc4d537cc04"
    end

    testpath.install resource("homebrew-test_apk")
    system bin/"redex", "--ignore-zipalign",
                        "-Jignore_no_keep_rules=true",
                        "redex-test.apk", "-o", "redex-test-out.apk"
    assert_path_exists testpath/"redex-test-out.apk"
  end
end
