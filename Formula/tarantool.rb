class Tarantool < Formula
  desc "In-memory database and Lua application server"
  homepage "https://tarantool.org/"
  url "https://download.tarantool.org/tarantool/1.9/src/tarantool-1.9.0.61.tar.gz"
  sha256 "0045aaf8be05e12957f8ad7cd249789ffddb3021d7adaa5d90aef3646bce26d2"
  revision 1
  head "https://github.com/tarantool/tarantool.git", :branch => "2.0", :shallow => false

  bottle do
    sha256 "d13407acd3af07a510b96448e8e9c3d28c73d5198c8ead7e9c7ccf2c761d6970" => :high_sierra
    sha256 "187494a7e726c3e5e698f24f1b60f4badf2e6346c5a4aedcc004eb66a043067d" => :sierra
    sha256 "626f2ffd8454ae39fc161da20522ccba5981bf54ac3e9c3f28447f630ad3cae2" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "icu4c"
  depends_on "openssl"
  depends_on "readline"

  def install
    sdk = MacOS::CLT.installed? ? "" : MacOS.sdk_path

    args = std_cmake_args

    args << "-DCMAKE_INSTALL_MANDIR=#{doc}"
    args << "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}"
    args << "-DCMAKE_INSTALL_LOCALSTATEDIR=#{var}"
    args << "-DENABLE_DIST=ON"
    args << "-DOPENSSL_ROOT_DIR=#{Formula["openssl"].opt_prefix}"
    args << "-DREADLINE_ROOT=#{Formula["readline"].opt_prefix}"
    args << "-DCURL_INCLUDE_DIR=#{sdk}/usr/include"
    args << "-DCURL_LIBRARY=/usr/lib/libcurl.dylib"

    system "cmake", ".", *args
    system "make"
    system "make", "install"
  end

  def post_install
    local_user = ENV["USER"]
    inreplace etc/"default/tarantool", /(username\s*=).*/, "\\1 '#{local_user}'"

    (var/"lib/tarantool").mkpath
    (var/"log/tarantool").mkpath
    (var/"run/tarantool").mkpath
  end

  test do
    (testpath/"test.lua").write <<~EOS
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
    EOS
    system bin/"tarantool", "#{testpath}/test.lua"
  end
end
