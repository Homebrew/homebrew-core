class Tarantool < Formula
  desc "In-memory database and Lua application server"
  homepage "https://tarantool.org/"
  url "https://download.tarantool.org/tarantool/src/tarantool-3.6.1.tar.gz"
  sha256 "2dd50c09b6fcb541b543d9c9d8eb7f09ddc4462627d1df073ff8da8b91fee078"
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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "c123d9add829d7463fded3659787b1c9cbe02aff9b09be9a81161b218b4e58de"
    sha256 cellar: :any,                 arm64_sequoia: "c0cffe6aecb74ad382449b11a4487743d9e1b647856b33e2dc298807ec722294"
    sha256 cellar: :any,                 arm64_sonoma:  "8c8d71ddbcf21ee22210faa55f2a80d09a0eee6adde5ad2b6a35cbc349991c42"
    sha256 cellar: :any,                 sonoma:        "3d7ed307fe9dc2672550cf0dbc556e86ba480fdefe209f480bf29b08e835e7c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "017e2952ddaf7eab4aa224591f775b9b8c911eed1dabcf941833b7f02d957e0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b3e09880ea5384a466276c2bb3c6d67b4ad7705bbccb48bba934fc3fbf525a3"
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
