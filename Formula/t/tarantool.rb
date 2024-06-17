class Tarantool < Formula
  desc "In-memory database and Lua application server"
  homepage "https://tarantool.org/"
  url "https://download.tarantool.org/tarantool/src/tarantool-3.1.0.tar.gz"
  sha256 "6df4383566a8bf3dcb417f798bd46c790dc96bf3b39bc9604acaba45288cc342"
  license "BSD-2-Clause"
  version_scheme 1
  head "https://github.com/tarantool/tarantool.git", branch: "master"

  livecheck do
    url :head
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8cfa0e21313a437204301b4b8a0962c03e1a24e638e4774c50183e9c0fad3fcc"
    sha256 cellar: :any,                 arm64_ventura:  "e7dbeb6e687dc6ae7525f87af52161a5dec0b2cdc0b1dfeb716794039b915412"
    sha256 cellar: :any,                 arm64_monterey: "360308ed989b3a1e94cba4c825a69b808c45a7e111221cbab4c9d02b091e1dcc"
    sha256 cellar: :any,                 sonoma:         "0810ab6811a55e499975f136e23b7b7eec8114591486da1f0f563cacab69caee"
    sha256 cellar: :any,                 ventura:        "a4251a66c93d633d9f9376007652b20b859f13f6c45d65581c18672896c6356d"
    sha256 cellar: :any,                 monterey:       "d87b02511c78237fca446709761b4d25d3b29a3cac9799312cc8ec02ef54e763"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91dd35c80872ae199de6b43b98db8d66be56b87c76fe41665e7e77d431cbd9bb"
  end

  depends_on "cmake" => :build
  depends_on "curl" # curl 8.4.0+
  depends_on "icu4c"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "readline"
  depends_on "zstd"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "libunwind"
  end

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
    args << "-DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}"
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

      args << "-DCURL_ROOT=#{Formula["curl"].opt_prefix}"
      args << "-DCURSES_NEED_NCURSES=ON"
      args << "-DCURSES_NCURSES_INCLUDE_PATH=#{sdk}/usr/include"
      args << "-DCURSES_NCURSES_LIBRARY=#{sdk}/usr/lib/libncurses.#{lib_suffix}"
      args << "-DICONV_INCLUDE_DIR=#{sdk}/usr/include"
    else
      args << "-DENABLE_BUNDLED_LIBUNWIND=OFF"
      args << "-DCURL_ROOT=#{Formula["curl"].opt_prefix}"
    end

    system "cmake", ".", *args
    system "make"
    system "make", "install"
  end

  def post_install
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
