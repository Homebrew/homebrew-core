class Tarantool < Formula
  desc "In-memory database and Lua application server"
  homepage "https://tarantool.org/"
  url "https://download.tarantool.org/tarantool/2.7/src/tarantool-2.7.2.0.tar.gz"
  sha256 "9dfbd67d7c46404507a13dfeac4169b53aaa4e4237a6b84e4bbe9435a4a30080"
  license "BSD-2-Clause"
  revision 1
  version_scheme 1
  head "https://github.com/tarantool/tarantool.git", shallow: false

  bottle do
    sha256 big_sur:  "2b8e07cad7ef54c58bbd6ff334bf43099489b00e748eff3199b1921770216df2"
    sha256 catalina: "7e1912a563511f0477922770c4fb459194aea9b59b838e27cad9fbf9f2a588ec"
    sha256 mojave:   "107064d70651c5512145cccd1fc89a8b734ded525b4b8e906aeee2eec4f60b21"
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
