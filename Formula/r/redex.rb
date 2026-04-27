class Redex < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Bytecode optimizer for Android apps"
  homepage "https://fbredex.com/"
  license "MIT"
  head "https://github.com/facebook/redex.git", branch: "main"

  stable do
    url "https://github.com/facebook/redex/archive/refs/tags/v2025.09.18.tar.gz"
    sha256 "49be286761fb89a223a9609d58faa141e584a0c6866bf083d8408357302ee2f8"

    # Patch to fix build with Python 3.14.
    # TODO: Remove in the next release.
    patch do
      url "https://github.com/facebook/redex/commit/b9c7d5abf922eea7e38bc6031607eb30e8482f38.patch?full_index=1"
      sha256 "6e644764d2e2b3a7b8e69c8887e738fc6c6099f5f4a3bb6738eae6fd5677da6a"
    end

    # Patch to remove stub_resource_optimizations
    patch do
      url "https://github.com/facebook/redex/commit/f2cc84464a7392fdb266136e9c0b4b37d26a0801.patch?full_index=1"
      sha256 "043f6b77e91033b64244734d92534de3aaae05b828436cd3cb19af7af1338ec4"
    end

    # Patch FindZlib.cmake to handle macOS SDK zlib via ZLIB_HOME.
    patch do
      url "https://github.com/facebook/redex/commit/a885d52ce6121ed96b78c511d1920116de10ff86.patch?full_index=1"
      sha256 "ca1321b1fb500203110f5da701106eaab89f61ecbdc62182e94f8747b17cfc65"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e06fdb01d04d9f3034df3e5d8fe15f018b35846a72e9100ed559019a690bec47"
    sha256 cellar: :any,                 arm64_sequoia: "f67e926b2befa3165251e26fd74e782b9e4682b83698f743c99499701dde663c"
    sha256 cellar: :any,                 arm64_sonoma:  "b9c8df2bfdf2a2fde8ad231a6ca457b5b2c9814a7ba69dc0ee60d135d0ba6822"
    sha256 cellar: :any,                 sonoma:        "9756ac7b8651a4270f4eb7ba663b9b9742f6d93686c2b10ec200977ac054c567"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bf568921ef0ef17b89405d0893023bdc9ed29c0317f5bd64ba4fc0df9ce4340"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f0bf2c78fe56fb7df4d9583e57d344905a437cf0453c2e748eb69c8274e17b2"
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
  # PR: https://github.com/facebook/redex/pull/982
  patch do
    url "https://github.com/facebook/redex/commit/f1d9211256ac03d92a4176bea36fb97bee581f41.patch?full_index=1"
    sha256 "d3ce5c0b758ae7f61c30ca7ebea115d782abe43af61672454874be9810201ce1"
  end

  def install
    zlib_home = if OS.linux?
      Formula["zlib-ng-compat"].opt_prefix
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
