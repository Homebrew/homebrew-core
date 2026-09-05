class Redex < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Bytecode optimizer for Android apps"
  homepage "https://fbredex.com/"
  url "https://github.com/facebook/redex/archive/refs/tags/v2026.04.30.tar.gz"
  sha256 "60c638403ce608b7d96d76592f4e2bfcb5e541b2eee33f97d06f771f2c147880"
  license "MIT"
  revision 1
  head "https://github.com/facebook/redex.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bedc7d74c8c6aae4dfde67293b461ddfb8cf0391466a0bca535377adb7546ab4"
    sha256 cellar: :any, arm64_sequoia: "8b7979ae9df58e485b86d4de4bdade6e851b7748a256c11ded8bd22f50580357"
    sha256 cellar: :any, arm64_sonoma:  "80f2572ec3edecb40908bc0de68f18625ec71ac6c21cba6143617e92ef5bd164"
    sha256 cellar: :any, sonoma:        "3392e2b95d7d3cf00d250e2875fa877f9844d289283470d0591b9a7434438ffd"
    sha256 cellar: :any, arm64_linux:   "a96632b9d002482b4b69a16a045cac8d05b46c0297d9362e447a7bc6d42c3fc7"
    sha256 cellar: :any, x86_64_linux:  "f0421685457e0b1657c294396973da261c0e3be40059a5a23c07ebb37ab907f8"
  end

  depends_on "cmake" => :build
  depends_on "libevent" => :build
  depends_on "libtool" => :build
  depends_on "boost"
  depends_on "jsoncpp"
  depends_on "python@3.14"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4d/5b/dc575711b6b8f2f866131a40d053e30e962e633b332acf7cd2c24843d83d/setuptools-69.2.0.tar.gz"
    sha256 "0ff4183f8f42cd8fa3acea16c45205521a4ef28f73c6391d8a25e92893134f2e"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  # Patch to allow redex.py to detect redex-binary
  patch do
    url "https://github.com/facebook/redex/commit/f1d9211256ac03d92a4176bea36fb97bee581f41.patch?full_index=1"
    sha256 "d3ce5c0b758ae7f61c30ca7ebea115d782abe43af61672454874be9810201ce1"
    type :unofficial
    resolves "https://github.com/facebook/redex/pull/982"
  end

  # Backport macOS SDK .tbd zlib detection, missing from the v2026.04.30 release
  patch do
    url "https://github.com/facebook/redex/commit/a885d52ce6121ed96b78c511d1920116de10ff86.patch?full_index=1"
    sha256 "ca1321b1fb500203110f5da701106eaab89f61ecbdc62182e94f8747b17cfc65"
    type :backport
    resolves "https://github.com/facebook/redex/pull/980"
  end

  def install
    zlib_home = if OS.linux?
      formula_opt_prefix("zlib-ng-compat")
    else
      MacOS.sdk_for_formula(self).path/"usr"
    end

    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources

    python_scripts = %w[
      apkutil
      redex.py
      gen_packed_apilevels.py
      tools/python/dex.py
      tools/python/dict_utils.py
      tools/python/file_extract.py
      tools/python/reach_graph.py
      tools/redex-tool/DexSqlQuery.py
      tools/redexdump-apk
    ]

    rewrite_shebang python_shebang_rewrite_info(venv.root/"bin/python"), *python_scripts

    args = %W[
      -DBUILD_TYPE=Shared
      -DENABLE_STATIC=OFF
      -DBUILD_SHARED_LIBS=ON
      -DZLIB_HOME=#{zlib_home}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    libexec.install bin.glob("*")
    chmod "+x", libexec/"redex.py"
    bin.write_exec_script libexec/"redex.py"
  end

  test do
    resource "homebrew-test_apk" do
      url "https://raw.githubusercontent.com/facebook/redex/fa32d542d4074dbd485584413d69ea0c9c3cbc98/test/instr/redex-test.apk"
      sha256 "7851cf2a15230ea6ff076639c2273bc4ca4c3d81917d2e13c05edcc4d537cc04"
    end

    (testpath/"homebrew-default.config").write <<~JSON
      {
        "redex": {
          "passes": [
            "ReBindRefsPass",
            "ResultPropagationPass",
            "BridgeSynthInlinePass",
            "FinalInlinePassV2",
            "DelSuperPass",
            "CommonSubexpressionEliminationPass",
            "MethodInlinePass",
            "PeepholePass",
            "ConstantPropagationPass",
            "LocalDcePass",
            "RemoveUnreachablePass",
            "DedupBlocksPass",
            "UpCodeMotionPass",
            "SingleImplPass",
            "ReorderInterfacesDeclPass",
            "ShortenSrcStringsPass",
            "CommonSubexpressionEliminationPass",
            "RegAllocPass",
            "CopyPropagationPass",
            "LocalDcePass",
            "ReduceGotosPass"
          ]
        },
        "compute_xml_reachability": false,
        "analyze_native_lib_reachability": false
      }
    JSON
    (testpath/"homebrew-default.pro").write "-keep class * { *; }\n"

    testpath.install resource("homebrew-test_apk")
    config = %W[
      --config #{testpath}/homebrew-default.config
      --proguard-config #{testpath}/homebrew-default.pro
    ]
    system bin/"redex.py", *config, "-u", "--ignore-zipalign", "--unpack-dest", "redex-test", "redex-test.apk"
    assert_path_exists testpath/"redex-test.redex_extracted_apk"
    assert_path_exists testpath/"redex-test.redex_dexen"
  end
end
