class Tarantool < Formula
  desc "In-memory database and Lua application server"
  homepage "https://tarantool.org/"
  url "https://download.tarantool.org/tarantool/1.7/src/tarantool-1.7.6.12.tar.gz"
  sha256 "c421ab57a9ed23528e8b3722255b801ef1baa2d631e0725c0ba014314e1b11de"
  revision 1
  head "https://github.com/tarantool/tarantool.git", :branch => "1.8", :shallow => false

  bottle do
    sha256 "799cf6445545a127478031d305d724d09da8371787f223004533e04630abb76f" => :high_sierra
    sha256 "df5b801e54ec587b4f26b5642a301c3b61e1170c27d7ef71ab534175612284d3" => :sierra
    sha256 "ab9e2aa1d325a6d50bad4e29ba8dede0315b71bf98e6c32349de7385c1223e14" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "icu4c"
  depends_on "openssl"
  depends_on "readline"

  def install
    sdk = MacOS::CLT.installed? ? "" : MacOS.sdk_path

    args = std_cmake_args

    args << "-DCMAKE_CXX_FLAGS=-Wno-c++11-narrowing"
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
