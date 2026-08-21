class Tarantool < Formula
  desc "In-memory database and Lua application server"
  homepage "https://tarantool.org/"
  url "https://hb.bizmrg.com/tarantool_repo/sources/tarantool-3.8.0.tar.gz"
  sha256 "ee10c839cfdce23f606d2c9787c0633ca9f0d69552a5df04b8a9bed2624c737f"
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
    sha256 cellar: :any, arm64_tahoe:   "e53c04f90824f10a3025937e22def881e766ea110772ad03d76de27ffa8e707f"
    sha256 cellar: :any, arm64_sequoia: "80866ec668a814568edc16775a1914509e68b3257ffbe22667ad07ca73e5b053"
    sha256 cellar: :any, arm64_sonoma:  "2e769080f9d6046ea414bb7564b9f7d7c1b35dd7f584c619ad857a81e47200bc"
    sha256 cellar: :any, sonoma:        "df2423c447ee7225832621a78186cea49e207f54750319737f184d1b71ab9403"
    sha256 cellar: :any, arm64_linux:   "ff77451ef969fb89eb602b45dc1b78f140b9957e435681d6456b5fd6fda6e7cc"
    sha256 cellar: :any, x86_64_linux:  "773afc14feb171592d789d02ee228c02c1839bbab1ac4e2002c4df8f5d8f3c33"
  end

  depends_on "cmake" => :build
  depends_on "icu4c@78"
  depends_on "libyaml"
  depends_on "openssl@3"
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
      -DOPENSSL_ROOT_DIR=#{formula_opt_prefix("openssl@3")}
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
