class Tarantool < Formula
  desc "In-memory database and Lua application server"
  homepage "https://tarantool.org/"
  url "https://download.tarantool.org/tarantool/src/tarantool-2.10.6.tar.gz"
  sha256 "461381d85ba0e6064605d40874d0e9ab8a4d5d153005906f72ff1d6d4a1dd071"
  license "BSD-2-Clause"
  version_scheme 1
  head "https://github.com/tarantool/tarantool.git", branch: "master"

  livecheck do
    url :head
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8fd7306f6fc1c9607f569baf39bd18e3141501f5107a1475eee6ccfce0f1e6b4"
    sha256 cellar: :any,                 arm64_monterey: "a87864bcd862585353a831e2e2357507def361dd5f1ad4cfc88fffde878c061d"
    sha256 cellar: :any,                 arm64_big_sur:  "47e8d4733700e36612fabdbacf2289fcaed1e0b98230e75afbc9be84bf1cd9f3"
    sha256 cellar: :any,                 ventura:        "187d0e460484b0303d400e14317b6058d9209d3337f79d753bbf27dd34e708ff"
    sha256 cellar: :any,                 monterey:       "96aefb2530927a9df4eca916702f1c007f1758d6dcc1c17180deb2f52c77016c"
    sha256 cellar: :any,                 big_sur:        "fbb211ceb5be0958ec76f9f1a3ea6e758b2bf1b91f7cd938cdc16e5898f0417e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e8c093a7bb37a8bb4e72325c03067bbe4ee89ddde4276b7e1a73f38e3041420"
  end

  depends_on "cmake" => :build
  depends_on "icu4c"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "readline"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  def install
    # Avoid keeping references to Homebrew's clang/clang++ shims
    inreplace "src/trivia/config.h.cmake",
              "#define COMPILER_INFO \"@CMAKE_C_COMPILER_ID@-@CMAKE_C_COMPILER_VERSION@\"",
              "#define COMPILER_INFO \"/usr/bin/clang /usr/bin/clang++\""

    args = std_cmake_args
    args << "-DCMAKE_INSTALL_MANDIR=#{doc}"
    args << "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}"
    args << "-DCMAKE_INSTALL_LOCALSTATEDIR=#{var}"
    args << "-DENABLE_DIST=ON"
    args << "-DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}"
    args << "-DREADLINE_ROOT=#{Formula["readline"].opt_prefix}"
    args << "-DENABLE_BUNDLED_LIBCURL=OFF"
    args << "-DENABLE_BUNDLED_LIBYAML=OFF"
    args << "-DENABLE_BUNDLED_ZSTD=OFF"

    if OS.mac?
      if MacOS.version >= :big_sur
        sdk = MacOS.sdk_path_if_needed
        lib_suffix = "tbd"
      else
        sdk = ""
        lib_suffix = "dylib"
      end

      args << "-DCURL_INCLUDE_DIR=#{sdk}/usr/include"
      args << "-DCURL_LIBRARY=#{sdk}/usr/lib/libcurl.#{lib_suffix}"
      args << "-DCURSES_NEED_NCURSES=ON"
      args << "-DCURSES_NCURSES_INCLUDE_PATH=#{sdk}/usr/include"
      args << "-DCURSES_NCURSES_LIBRARY=#{sdk}/usr/lib/libncurses.#{lib_suffix}"
      args << "-DICONV_INCLUDE_DIR=#{sdk}/usr/include"
    else
      args << "-DCURL_ROOT=#{Formula["curl"].opt_prefix}"
    end

    system "cmake", ".", *args
    system "make"
    system "make", "install"
  end

  def post_install
    local_user = ENV["USER"]
    inreplace etc/"default/tarantool", /(username\s*=).*/, "\\1 '#{local_user}'"

    (var/"lib/tarantool").mkpath
    (var/"log/tarantool").mkpath
    (var/"run/tarantool").mkpath
  end

  test do
    (testpath/"test.lua").write <<~EOS
      box.cfg{}
      local s = box.schema.create_space("test")
      s:create_index("primary")
      local tup = {1, 2, 3, 4}
      s:insert(tup)
      local ret = s:get(tup[1])
      if (ret[3] ~= tup[3]) then
        os.exit(-1)
      end
      os.exit(0)
    EOS
    system bin/"tarantool", "#{testpath}/test.lua"
  end
end
