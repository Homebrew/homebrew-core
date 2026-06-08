class Tarantool < Formula
  desc "In-memory database and Lua application server"
  homepage "https://tarantool.org/"
  url "https://download.tarantool.org/tarantool/src/tarantool-3.7.0.tar.gz"
  sha256 "81b044c4852e33115faac851f9542b99af94ccb1d5d9e3454a6922c5d0794185"
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
    sha256 cellar: :any,                 arm64_tahoe:   "153a61210990aaad32a5c5d6232e9d3c0a70294ec9516e20f7c9de3bbb802025"
    sha256 cellar: :any,                 arm64_sequoia: "1c9abf2f017cae55faeb177b3e46055c8db84167fbe4f0ee84b8b1efdb2db3e9"
    sha256 cellar: :any,                 arm64_sonoma:  "b18b48dd5540a1c61fd26490ec61deb8c201fc713a155c99d2ba34834aea9d19"
    sha256 cellar: :any,                 sonoma:        "a80330c3819e6662351de0ddbc1a07c3798b1e29da2146b54a7415755248741d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d9077c4c7a554b59ce9fc6a25c652f394bb08c5c11c686e655a290747f9b8cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6b1304ab43fb31b60c21889f48df3b89ca989e00c6c5488c7b41e4783528771"
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
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
      -DREADLINE_ROOT=#{Formula["readline"].opt_prefix}
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
