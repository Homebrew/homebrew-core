class Tarantool < Formula
  desc "In-memory database and Lua application server"
  homepage "https://tarantool.org/"
  url "https://download.tarantool.org/tarantool/src/tarantool-3.5.0.tar.gz"
  sha256 "396780491b4f01c75f7098056e9a21562a687234085543bf52a5c5a6905f2dbc"
  license "BSD-2-Clause"
  version_scheme 1
  head "https://github.com/tarantool/tarantool.git", branch: "master"

  # The upstream release page (https://www.tarantool.io/en/doc/latest/release/)
  # simply links to GitHub releases, so we check the "latest" release directly.
  livecheck do
    url :head
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8dbca5e09bab4ef910aeb06b4daeac4e282309105c7f5859bec7bc17d88f8fe4"
    sha256 cellar: :any,                 arm64_sequoia: "6c5828162564addff9cd3ed7b52022bceb0d0ed3ec5d94fa0615b1ca39577d64"
    sha256 cellar: :any,                 arm64_sonoma:  "c219179af278c35dc4b4de390e52800546de9a545cf611a1df2b830916349281"
    sha256 cellar: :any,                 arm64_ventura: "f2e041b8e088e58c76d93f05a8d27d4f9ae4e5845d9de8a41e8cae3c27dd299a"
    sha256 cellar: :any,                 sonoma:        "314369f182f312fdcb1aebc4b8e91808e23abe386070b9bc6e535e3fce7f9ce1"
    sha256 cellar: :any,                 ventura:       "e73a676ed760eabd5d4ca31d4aa1bd1007e485044fe02026287d9085cdec903b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "590263b5e1ecad50b34a3af8b03399cb455ee5095db304eb56de53dc8cfef5ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0501b2ce4c00e8631849fd5218e9d6770e32c0c815bbf22cd0943683a417eeab"
  end

  depends_on "cmake" => :build
  depends_on "curl" # curl 8.4.0+
  depends_on "icu4c@77"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "readline"
  depends_on "zstd"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "libunwind"
  end

  def install
    # Workaround for clang >= 16 until upstream fix is available[^1].
    # Also, trying to apply LuaJIT commit[^2] worked on Xcode 16 but caused issue on Xcode 15.
    #
    # [^1]: https://github.com/tarantool/tarantool/issues/10566
    # [^2]: https://github.com/LuaJIT/LuaJIT/commit/2240d84464cc3dcb22fd976f1db162b36b5b52d5
    ENV.append "LDFLAGS", "-Wl,-no_deduplicate" if DevelopmentTools.clang_build_version >= 1600

    icu4c = deps.find { |dep| dep.name.match?(/^icu4c(@\d+)?$/) }
                .to_formula
    args = %W[
      -DCMAKE_INSTALL_SYSCONFDIR=#{etc}
      -DCMAKE_INSTALL_LOCALSTATEDIR=#{var}
      -DENABLE_DIST=ON
      -DCURL_ROOT=#{Formula["curl"].opt_prefix}
      -DCURL_ROOT_DIR=#{Formula["curl"].opt_prefix}
      -DICU_ROOT=#{icu4c.opt_prefix}
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
      -DREADLINE_ROOT=#{Formula["readline"].opt_prefix}
      -DENABLE_BUNDLED_LIBCURL=OFF
      -DENABLE_BUNDLED_LIBUNWIND=OFF
      -DENABLE_BUNDLED_LIBYAML=OFF
      -DENABLE_BUNDLED_ZSTD=OFF
      -DLUAJIT_NO_UNWIND=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def post_install
    (var/"lib/tarantool").mkpath
    (var/"log/tarantool").mkpath
    (var/"run/tarantool").mkpath
  end

  test do
    (testpath/"test.lua").write <<~LUA
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
    LUA
    system bin/"tarantool", "#{testpath}/test.lua"
  end
end
