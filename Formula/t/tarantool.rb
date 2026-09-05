class Tarantool < Formula
  desc "In-memory database and Lua application server"
  homepage "https://tarantool.org/"
  url "https://hb.bizmrg.com/tarantool_repo/sources/tarantool-3.8.1.tar.gz"
  sha256 "84ba3129bcfc2a7eeb30cea17a955b7b3f96615b960497d5ca60eac1d14fd090"
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
    sha256 cellar: :any, arm64_tahoe:   "182d0696408d991dde6018d3e1439fcebc56da6e3deb4b921c95e4f74069c7b2"
    sha256 cellar: :any, arm64_sequoia: "94919ba032d2193a255b688dd47a894076a44359ba1e2540b25349d219c71f82"
    sha256 cellar: :any, arm64_sonoma:  "44866d67eb82494f3bacc0c6c5e0c3531d89eb1fcceca77b688a669de33b4c5d"
    sha256 cellar: :any, arm64_linux:   "ac6e418b0b004cdfd65809559313e693e054c7ccf0513b50cd99695f618b6a1b"
    sha256 cellar: :any, x86_64_linux:  "fb2aaeb01748f6ab1f0cdfd67bdd83e92a2d494044437c2cb362451c21f7bd88"
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
