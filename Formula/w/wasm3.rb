class Wasm3 < Formula
  desc "High performance WebAssembly interpreter"
  homepage "https://twitter.com/wasm3_engine"
  url "https://github.com/wasm3/wasm3/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "cab79ce74bcac25bbf80b5ebe14af9795b9bac30b05ee8f620a3bc8002f3b8e6"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "535442b0baca3955b8b1a2a863a3c1435ea6f95905c4d65bd986190a5c47d0fd"
    sha256 cellar: :any, arm64_sequoia: "d7852e9d45aa2640f29069800eda68c8100238a6d09d89562e9a30b162d14a55"
    sha256 cellar: :any, arm64_sonoma:  "333a6c7876562076b43d00bd81ac1f33589d87ba4fab58b35091e3411052c94d"
    sha256 cellar: :any, sonoma:        "8de67257d87de88ccd2f8fb154e7115730bc9944b392e9639d7be967f4b80432"
    sha256 cellar: :any, arm64_linux:   "6e341d6fed466a7ad6f4f0f2aff871ee29a5caa972336152b65f9da6cdb799ce"
    sha256 cellar: :any, x86_64_linux:  "0fd6fcd632856e0c0c728afe74cbd7c4d87f1a243b0a1bedec5fb78ffc433b67"
  end

  depends_on "cmake" => :build
  depends_on "uvwasi"

  def install
    # Unbundle uvwasi and link to shared library
    inreplace "CMakeLists.txt",
              "target_link_libraries(${OUT_FILE} uvwasi_a uv_a)",
              "target_link_libraries(${OUT_FILE} uvwasi::uvwasi)"

    # We bypass brew's dependency provider to set `FETCHCONTENT_TRY_FIND_PACKAGE_MODE`
    # which redirects FetchContent_Declare() to find_package() and helps find our `uvwasi`.
    # To re-block fetches, we use the not-recommended `FETCHCONTENT_FULLY_DISCONNECTED`.
    system "cmake", "-S", ".", "-B", "build",
                    "-DHOMEBREW_ALLOW_FETCHCONTENT=ON",
                    "-DFETCHCONTENT_FULLY_DISCONNECTED=ON",
                    "-DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS",
                    *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/wasm3"
  end

  test do
    resource "homebrew-fib32.wasm" do
      url "https://github.com/wasm3/wasm3/raw/ae7b69b6d2f4d8561c907d1714d7e68b48cddd9e/test/lang/fib32.wasm"
      sha256 "80073d9035c403b6caf62252600c5bda29cf2fb5e3f814ba723640fe047a6b87"
    end

    testpath.install resource("homebrew-fib32.wasm")

    # Run function fib(24) and check the result is 46368
    assert_equal "Result: 46368", shell_output("#{bin}/wasm3 --func fib fib32.wasm 24 2>&1").strip
  end
end
