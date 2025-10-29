class Redex < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Bytecode optimizer for Android apps"
  homepage "https://fbredex.com/"
  url "https://github.com/facebook/redex/archive/refs/tags/v2025.09.18.tar.gz"
  sha256 "49be286761fb89a223a9609d58faa141e584a0c6866bf083d8408357302ee2f8"
  license "MIT"
  head "https://github.com/facebook/redex.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "ccd598d35c980d9c5220de5fa1a9bdcf3ff6c9cdd74e20f20143f7dc3dee5694"
    sha256 cellar: :any,                 arm64_sequoia: "acd97e017326b3c2a1cff2eef31078a79ea1f5a0129531c31c1b2566e70648d4"
    sha256 cellar: :any,                 arm64_sonoma:  "cd443c5e4f40643b584184041c3c6d4809bc6c7127bb64a67c169d89269029d2"
    sha256 cellar: :any,                 sonoma:        "b499a2a789dd133952eb96a2c0a3c591daa178248a352db5bf1c62cc687f492e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bfe2a1cdb1329411574b37c837686859e283dbcf22175a1a5bd9486b35b082e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f1ccda8d1eb737e03a2a3e01b34b171bde12f49a896b48224e63e95af76c12f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libevent" => :build
  depends_on "libtool" => :build
  depends_on "boost"
  depends_on "jsoncpp"
  depends_on "python@3.14"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4d/5b/dc575711b6b8f2f866131a40d053e30e962e633b332acf7cd2c24843d83d/setuptools-69.2.0.tar.gz"
    sha256 "0ff4183f8f42cd8fa3acea16c45205521a4ef28f73c6391d8a25e92893134f2e"
  end

  def install
    if build.stable?
      # https://github.com/facebook/redex/issues/457
      inreplace "Makefile.am", "/usr/include/jsoncpp", Formula["jsoncpp"].opt_include
      # Work around missing include. Fixed upstream but code has been refactored
      # Ref: https://github.com/facebook/redex/commit/3f4cde379da4657068a0dbe85c03df558854c31c
      ENV.append "CXXFLAGS", "-include set"
      # Help detect Boost::Filesystem and Boost::System during ./configure.
      # TODO: Remove in the next release.
      ENV.cxx11
    end

    venv = virtualenv_create(libexec, "python3.14")
    venv.pip_install resources

    python_scripts = %w[
      apkutil
      redex.py
      tools/python/dex.py
      tools/python/dict_utils.py
      tools/python/file_extract.py
      tools/python/reach_graph.py
      tools/redex-tool/DexSqlQuery.py
      tools/redexdump-apk
    ]
    rewrite_shebang python_shebang_rewrite_info(venv.root/"bin/python"), *python_scripts

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
    system bin/"redex", "--ignore-zipalign", "redex-test.apk", "-o", "redex-test-out.apk"
    assert_path_exists testpath/"redex-test-out.apk"
  end
end
