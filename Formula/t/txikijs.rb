class Txikijs < Formula
  desc "Tiny JavaScript runtime"
  homepage "https://txikijs.org"
  # pull from git tag to get submodules
  url "https://github.com/saghul/txiki.js.git",
    tag:      "v26.3.0",
    revision: "9419f742e0c0470af500a4513ad4f529937d4fe7"
  license "MIT"
  head "https://github.com/saghul/txiki.js.git", branch: "master"

  depends_on "cmake" => :build
  # txiki.js builds WAMR with SIMD support, which requires SIMDe via FetchContent
  depends_on "simde" => :build

  depends_on "ada-url"
  depends_on "libuv"
  depends_on "mimalloc"
  depends_on "sqlite"

  uses_from_macos "libffi"

  def install
    inreplace "CMakeLists.txt" do |s|
      # mimalloc
      s.gsub! "add_subdirectory(deps/mimalloc EXCLUDE_FROM_ALL)", "find_package(mimalloc REQUIRED)"

      # libuv
      s.gsub! "add_subdirectory(deps/libuv EXCLUDE_FROM_ALL)", "find_package(libuv REQUIRED)"
      s.gsub! "target_link_libraries(tjs PUBLIC uv_a)", "target_link_libraries(tjs PUBLIC libuv::uv)"
      s.gsub! 'set(LWS_LIBUV_LIBRARIES uv_a CACHE STRING "" FORCE)',
              'set(LWS_LIBUV_LIBRARIES libuv::uv CACHE STRING "" FORCE)'
      s.gsub! 'set(LWS_LIBUV_INCLUDE_DIRS "${CMAKE_CURRENT_SOURCE_DIR}/deps/libuv/include" CACHE STRING "" FORCE)',
              "set(LWS_LIBUV_INCLUDE_DIRS \"#{Formula["libuv"].opt_include}\" CACHE STRING \"\" FORCE)"

      # sqlite
      s.gsub! "add_subdirectory(deps/sqlite3 EXCLUDE_FROM_ALL)", ""

      # ada-url
      s.gsub! "add_subdirectory(deps/ada EXCLUDE_FROM_ALL)", ""
    end

    system "cmake", "-S", ".", "-B", "build",
           "-DFETCHCONTENT_SOURCE_DIR_SIMDE=#{Formula["simde"].opt_prefix}",
           *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/tjs"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tjs --version")
    assert_equal "hello", shell_output("#{bin}/tjs eval \"console.log('hello')\"").strip
  end
end
