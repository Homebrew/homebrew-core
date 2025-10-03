class Wasm3 < Formula
  desc "High performance WebAssembly interpreter"
  homepage "https://github.com/wasm3/wasm3"
  url "https://github.com/wasm3/wasm3/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "b778dd72ee2251f4fe9e2666ee3fe1c26f06f517c3ffce572416db067546536c"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "67558c58d6f3470d32cc63b037032141ef9d5333b140266449b61ce990b0e5f0"
    sha256 cellar: :any,                 arm64_sequoia: "8cbba5eaf9cb8d51d1b3f736027239a2982316e1019fa3cc6f1fa2b368c2c0ca"
    sha256 cellar: :any,                 arm64_sonoma:  "1ce007a2ef41fb969587a79186545562851c847df980b9d9c5e240126dd7c680"
    sha256 cellar: :any,                 sonoma:        "b73049c21f9f23a48183a202350067d97499166bc56645b724f04a41549e37b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ecffe5df21d1f012c6a2139c8cb57e5673a390e0352b1250deef8a1004c171e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81583583d30963a9a92c39f2dad088571eff6ae11b3617bc8b39f585475161a0"
  end

  depends_on "cmake" => :build
  depends_on "uvwasi"

  def install
    # Unbundled uvwasi and link to shared library
    inreplace "CMakeLists.txt" do |s|
      s.gsub! "FetchContent_GetProperties(uvwasi)",
              "FetchContent_MakeAvailable(uvwasi)"
      s.gsub! "target_link_libraries(${OUT_FILE} uvwasi_a uv_a)",
              "target_link_libraries(${OUT_FILE} uvwasi::uvwasi)"
    end

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
