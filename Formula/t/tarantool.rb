class Tarantool < Formula
  desc "In-memory database and Lua application server"
  homepage "https://tarantool.org/"
  url "https://download.tarantool.org/tarantool/src/tarantool-3.4.0.tar.gz"
  sha256 "3ff1e8de285943eedef6b2cd14caacb51e7998d9da2e4d75eb4d9a770b3173b4"
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
    sha256 cellar: :any,                 arm64_sequoia: "73684e6d5d5a89273b6a87cf2557983a269b71e75ce60139fbb3b6a404fe88ad"
    sha256 cellar: :any,                 arm64_sonoma:  "102b5400e01ce56e4f576b7e533550d3baf17d9e338cf59658102491a925a9be"
    sha256 cellar: :any,                 arm64_ventura: "0b87ea083232f4b91b1ea94258bb89bbb51c9b43c412a057e16d1aa915101725"
    sha256 cellar: :any,                 sonoma:        "8140e9c6b27304a62ebc8ef8abb3840c6cf7b95c50f58a7987a9debcf24d5b02"
    sha256 cellar: :any,                 ventura:       "5110a32a70c67ba1a9c50ce13bd87922bfe65c780fc92197e34b9294c39b1bf3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f302f6f11b0a9ca7fee5ad2903d29e70ee806774adf0de1e4c519f9c45210bb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2dc785b9f64d0ca6fd04c859a1235edabc33bed12e32b6940aec6b91c317312"
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
