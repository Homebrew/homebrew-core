class Tarantool < Formula
  desc "In-memory database and Lua application server"
  homepage "https://tarantool.org/"
  url "https://download.tarantool.org/tarantool/1.7/src/tarantool-1.7.6.12.tar.gz"
  sha256 "c421ab57a9ed23528e8b3722255b801ef1baa2d631e0725c0ba014314e1b11de"
  head "https://github.com/tarantool/tarantool.git", :branch => "1.8", :shallow => false

  bottle do
    sha256 "20af4f98963fdc9321e54352b8219ff4a542bc8ccb44a3a1c2a01b0825a93002" => :high_sierra
    sha256 "a03bec9547369bcfc1cbe982207a6268561e4e854e2cda79d1881759208e041a" => :sierra
    sha256 "89ea22c96a84d0924e23f48047d401143cb49c9fe44ddf1f5d192731475d88a2" => :el_capitan
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
