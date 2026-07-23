class Redex < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Bytecode optimizer for Android apps"
  homepage "https://fbredex.com/"
  url "https://github.com/facebook/redex/archive/refs/tags/v2026.04.30.tar.gz"
  sha256 "60c638403ce608b7d96d76592f4e2bfcb5e541b2eee33f97d06f771f2c147880"
  license "MIT"
  head "https://github.com/facebook/redex.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "32f739c723e58daaf41aa654de4131ab30615c9e58b3cc236fbbf1b3d3e614e7"
    sha256 cellar: :any, arm64_sequoia: "c93576486cf574355e2ca3d80ccc585dfa27da29c43bbcbbcc6921e376a1c8a3"
    sha256 cellar: :any, arm64_sonoma:  "b00f40d922448092e969721c8bdc157853bccace0163d088df48ae2035576112"
    sha256 cellar: :any, sonoma:        "2e57edc7c2c16f166a50ddca433909053602769a67577852acf2eed99315f06f"
    sha256 cellar: :any, arm64_linux:   "65153d035700f0859adb7fcb523ef9d1ff13b972231be182e683bc4ba8a440ec"
    sha256 cellar: :any, x86_64_linux:  "3c2b5fb75e403a1356a4fab208a21554ff26fd59e68ed0bd3005294004d48a9f"
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

    venv = virtualenv_create(libexec, "python3.14")
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
