class Tarantool < Formula
  desc "In-memory database and Lua application server"
  homepage "https://tarantool.org/"
  url "https://download.tarantool.org/tarantool/src/tarantool-3.3.2.tar.gz"
  sha256 "c518d6f7a5737ab1124227e8c9bac9669f94331181240ce9f085fcf1cfc7972a"
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
    sha256 cellar: :any,                 arm64_sequoia: "103dd702e7f807ddd4b77832dede095353bfe1f2a74d306d27e797d749fb1786"
    sha256 cellar: :any,                 arm64_sonoma:  "8ea02574509bafa3e1b499c240eee26845deb176b507ddea4915864602b799e8"
    sha256 cellar: :any,                 arm64_ventura: "5eaa6b0f175bfc88724e2bfc56bf3469da5bb750b1cd4a138110b17b9a1a24ae"
    sha256 cellar: :any,                 sonoma:        "34449549a6a1b95867b0389a90aacc62370d2d126f06bf3cae0f663090ce4075"
    sha256 cellar: :any,                 ventura:       "0d722ed06b548b9f92f60b2597415f64ed9a4e19354364ecdc9cfcfb786e7729"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6c0b6b817b00ab3256f9b5797f000b3af57c63934a17e710bfdad61826a41cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d35e57ccb98cb3368d0f43bf6382e0bbb39256d73dacb13811b9b3a3a01016c3"
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

  # cmake 4 build patch, upstream pr ref, https://github.com/tarantool/tarantool/pull/11382
  patch do
    url "https://github.com/tarantool/tarantool/commit/68d591d8eb43d0a5de35cf7492955f18598629f2.patch?full_index=1"
    sha256 "7aeace515b991cf45a477e706a69b2ee5621d45a0394065bf75b92dcb1086534"
  end

  def install
    # cmake 4 build patch for third parties
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"

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
