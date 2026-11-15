class Tarantool < Formula
  desc "In-memory database and Lua application server"
  homepage "https://tarantool.org/"
  url "https://hb.bizmrg.com/tarantool_repo/sources/tarantool-3.9.0.tar.gz"
  sha256 "32d8ec8489b7f7bb2b22d89b801039334c53462046998aa019588ec8ee03419b"
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
    sha256 cellar: :any, arm64_golden_gate: "f618eddaf4623349b7862c51b33f90596a36adc7d70125ab9c5809c6d3e33e2a"
    sha256 cellar: :any, arm64_tahoe:       "69e51ceadecce0a6c62f2164701f5f3855269dfa967e884203a4779e6cfaf767"
    sha256 cellar: :any, arm64_sequoia:     "bf46e1dadea709cf177cad6885bad6633d0142561f4e2d00e7b4483e1c10454c"
    sha256 cellar: :any, arm64_linux:       "257a0e1c81c7972763696a68828891947e492ddcdc2e81e3c5326660200fa70f"
    sha256 cellar: :any, x86_64_linux:      "d2baaf2211c18dbae48a65ad23c7a3c3e0567388b56496e2681e07a9db9e8494"
  end

  depends_on "cmake" => :build
  depends_on "icu4c@79"
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
