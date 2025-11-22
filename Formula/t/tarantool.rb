class Tarantool < Formula
  desc "In-memory database and Lua application server"
  homepage "https://tarantool.org/"
  url "https://download.tarantool.org/tarantool/src/tarantool-3.5.1.tar.gz"
  sha256 "a48e5734a6714223ce6719cbef94832c5b92d784ea265dca305195aa05f799ab"
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
    sha256 cellar: :any,                 arm64_tahoe:   "4b2e725a461b753f134a008389380a54f799016ea64922d934568ce7163b6597"
    sha256 cellar: :any,                 arm64_sequoia: "7720805abfcc25e3b0ab85ee21c7348f5f442bc524c62bcde3c3f88825ef0734"
    sha256 cellar: :any,                 arm64_sonoma:  "ad6d9ea2b6aa5c514676f76e35a34e336d03305236b07b4e9db9f99863bcb13f"
    sha256 cellar: :any,                 sonoma:        "bb51bcaa26a6dd9aeec3a7260d35addfa9ec0ac4c88cf07a89980c5a613e8c34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1849546cd213cc0f10b266917d65275fd6bb9f21788190ee7727c0d01b75afe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d6f59fd0dc93fb8656c7d254cbaaae03c63ff47125a0aaae8f14d52bbac300f"
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
