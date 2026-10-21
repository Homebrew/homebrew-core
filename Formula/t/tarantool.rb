class Tarantool < Formula
  desc "In-memory database and Lua application server"
  homepage "https://tarantool.org/"
  url "https://hb.bizmrg.com/tarantool_repo/sources/tarantool-3.8.1.tar.gz"
  sha256 "84ba3129bcfc2a7eeb30cea17a955b7b3f96615b960497d5ca60eac1d14fd090"
  license "BSD-2-Clause"
  revision 1
  version_scheme 1
  head "https://github.com/tarantool/tarantool.git", branch: "master"

  # The upstream release page (https://www.tarantool.io/en/doc/latest/release/)
  # simply links to GitHub releases, so we check the "latest" release directly.
  livecheck do
    url :head
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "106434fbb91a2becd263891a5f3eacc9e56026ce1b5b07933601ec64b02b139d"
    sha256 cellar: :any, arm64_tahoe:       "94c7be9c5a1a09fee56892433593e1fde94b8ebbe055c764ce7221c40c1eaeea"
    sha256 cellar: :any, arm64_sequoia:     "868ef590aa257d6fab8a4c3b8b7cf0bdc1d3a56928a2d139125a4b7b257f20b1"
    sha256 cellar: :any, arm64_linux:       "162b60397c56bc1e684d42584161dc3ecd8eeb00baeea13ab618e9c5ffc26466"
    sha256 cellar: :any, x86_64_linux:      "23d3bb77b66ed8a28a6f1167a2b889ca9f3fc21564e02fb39c00483698643d18"
  end

  depends_on "cmake" => :build
  depends_on "icu4c@78"
  depends_on "libyaml"
  depends_on "openssl@4"
  depends_on "readline"
  depends_on "zstd"

  uses_from_macos "curl", since: :sonoma # curl 8.4.0+
  uses_from_macos "ncurses"

  on_linux do
    depends_on "libunwind"
  end

  def install
    icu4c = deps.find { |dep| dep.name.match?(/^icu4c(@\d+)?$/) }
                .to_formula
    args = %W[
      -DCMAKE_INSTALL_SYSCONFDIR=#{etc}
      -DCMAKE_INSTALL_LOCALSTATEDIR=#{var}
      -DENABLE_DIST=ON
      -DICU_ROOT=#{icu4c.opt_prefix}
      -DOPENSSL_ROOT_DIR=#{formula_opt_prefix("openssl@4")}
      -DREADLINE_ROOT=#{formula_opt_prefix("readline")}
      -DENABLE_BUNDLED_LIBCURL=OFF
      -DENABLE_BUNDLED_LIBUNWIND=OFF
      -DENABLE_BUNDLED_LIBYAML=OFF
      -DENABLE_BUNDLED_ZSTD=OFF
      -DLUAJIT_NO_UNWIND=ON
    ]
    args << "-DCURL_ROOT_DIR=#{MacOS.sdk_for_formula(self).path}/usr" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

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
    system bin/"tarantool", testpath/"test.lua"
  end
end
