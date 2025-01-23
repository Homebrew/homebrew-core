class Tarantool < Formula
  desc "In-memory database and Lua application server"
  homepage "https://tarantool.org/"
  url "https://download.tarantool.org/tarantool/src/tarantool-3.3.1.tar.gz"
  sha256 "c0f9d2160da2fa73a7dfb7e87d064d35554bf90358464e4c4ab9cced4695264e"
  license "BSD-2-Clause"
  version_scheme 1
  head "https://github.com/tarantool/tarantool.git", branch: "master"

  livecheck do
    url :head
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f03e8db8b668fe87a24439a71f3bbc52c3226fadf791b83061f1926a5c3e8352"
    sha256 cellar: :any,                 arm64_sonoma:  "4b98a50aca0c19485215f3e9c5c461e5870e72370bb7459a84d7fc5d9ea9824e"
    sha256 cellar: :any,                 arm64_ventura: "b8ba71cd9c98e584949bf3e19f27a1f4346951911b6e45f2367cb7fd40f09be2"
    sha256 cellar: :any,                 sonoma:        "5eaad296be43d3ef6bda96f740ed7eeddf66ec2c60b5922ae441991974bdde45"
    sha256 cellar: :any,                 ventura:       "9d64cfee36b26abedbf58ab12296fcb6045ee58c14ac0cc2dbb2dc417e1f84ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e98ef1935e7ceee4a5e0a816207decec98c2e984ecb6062b79a27c3d46f81b9"
  end

  depends_on "cmake" => :build
  depends_on "curl" # curl 8.4.0+
  depends_on "icu4c@76"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "readline"
  depends_on "zstd"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "libunwind"
  end

  def install
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
