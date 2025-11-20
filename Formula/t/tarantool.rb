class Tarantool < Formula
  desc "In-memory database and Lua application server"
  homepage "https://tarantool.org/"
  url "https://download.tarantool.org/tarantool/src/tarantool-3.5.0.tar.gz"
  sha256 "396780491b4f01c75f7098056e9a21562a687234085543bf52a5c5a6905f2dbc"
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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "f51f501b3893c3bda04da069805c005b2689acd4b99f4dcb1e3ce52b15be818d"
    sha256 cellar: :any,                 arm64_sequoia: "ba843e171a6ed888728c290851128df7643aa3286559f4b4cdd298aa8226f368"
    sha256 cellar: :any,                 arm64_sonoma:  "1135c1ba7178f8041b9e40d27f41ebf12cb6f71f2c0f56ba52fb0c215e22125c"
    sha256 cellar: :any,                 sonoma:        "af22c843f3f0e759fe6ef244c593de3ef139a840d02368173f8beeb5d65d4843"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f5b619cc81e0f22a1540c9234f33989287464ee3b70f1b0e348744875bdc754"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d9bfcd43ac016630fa6d37fc91977375bb9b44071dbc1cbbbe23c0f68f69d09"
  end

  depends_on "cmake" => :build
  depends_on "curl" # curl 8.4.0+
  depends_on "icu4c@78"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "readline"
  depends_on "zstd"

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
