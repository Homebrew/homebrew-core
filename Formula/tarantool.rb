class Tarantool < Formula
  desc "In-memory database and Lua application server"
  homepage "https://tarantool.org/"
  url "https://download.tarantool.org/tarantool/src/tarantool-2.10.3.tar.gz"
  sha256 "d1e38bfce10812593419979186497e7d7b59c5a233bab39353fcbf24b389f232"
  license "BSD-2-Clause"
  version_scheme 1
  head "https://github.com/tarantool/tarantool.git", branch: "master"

  livecheck do
    url :head
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "68923a6eafab8d61f0e4af4cc464a87c19e25a8b5f25d80c974062d5e5b7c779"
    sha256 cellar: :any,                 arm64_big_sur:  "d750f5fa03336aa57dd2929e179da3c2535501ba7c21ca5d785b03de14c452b3"
    sha256                               monterey:       "1c4383b5c82344730574669cfdf0eb3686165bd6e13685d361b8c38018a4ea1d"
    sha256                               big_sur:        "8292d82ce5bf7111ddd14889304a6880902911d9b4f4ddd850768c3ae2c93c36"
    sha256                               catalina:       "03be144a864ff9c821f745e1dacf4645329f49e495ee8579a60a71dab13d7223"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62a9293ccdd5b30b32426c322a5dd737a53cba4ed4de1584fb75ca2d1dca9e35"
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
              "#define COMPILER_INFO \"@CMAKE_C_COMPILER@ @CMAKE_CXX_COMPILER@\"",
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
