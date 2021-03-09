class Tarantool < Formula
  desc "In-memory database and Lua application server"
  homepage "https://tarantool.org/"
  url "https://download.tarantool.org/tarantool/2.6/src/tarantool-2.6.2.0.tar.gz"
  sha256 "eb605672493b89b182421f335d527139ab01c9abef036dc72014793b519f03a0"
  license "BSD-2-Clause"
  revision 1
  version_scheme 1
  head "https://github.com/tarantool/tarantool.git", shallow: false

  bottle do
    sha256 cellar: :any, big_sur:  "1ba6353c8f4a8a65534af280be5c0dd84760da5fcc38ff29a3c9ce5639aa570d"
    sha256 cellar: :any, catalina: "0f97472315f980a698f8059ee17f50aa6cc8fc4b8a713defc1a8328ccb1d8f63"
    sha256 cellar: :any, mojave:   "f5c648992a606ac41ff5c6ef7048866cc2efa0685bd0a823b8fa51e98f2f5416"
  end

  depends_on "cmake" => :build
  depends_on "icu4c"
  depends_on "openssl@1.1"
  depends_on "readline"

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  def install
    if MacOS.version >= :big_sur
      sdk = MacOS.sdk_path_if_needed
      lib_suffix = "tbd"
    else
      sdk = ""
      lib_suffix = "dylib"
    end

    # Necessary for luajit to build on macOS Mojave (see luajit formula)
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

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
    args << "-DCURL_INCLUDE_DIR=#{sdk}/usr/include"
    args << "-DCURL_LIBRARY=#{sdk}/usr/lib/libcurl.#{lib_suffix}"
    args << "-DCURSES_NEED_NCURSES=TRUE"
    args << "-DCURSES_NCURSES_INCLUDE_PATH=#{sdk}/usr/include"
    args << "-DCURSES_NCURSES_LIBRARY=#{sdk}/usr/lib/libncurses.#{lib_suffix}"
    args << "-DICONV_INCLUDE_DIR=#{sdk}/usr/include"

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
