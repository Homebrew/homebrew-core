class Tarantool < Formula
  desc "In-memory database and Lua application server"
  homepage "https://tarantool.org/"
  url "https://download.tarantool.org/tarantool/1.7/src/tarantool-1.7.5.184.tar.gz"
  sha256 "3c95948b90ef17ec772b09532aaaef7a71c75d2b13cbe192e6dd1796069afd01"
  revision 1
  head "https://github.com/tarantool/tarantool.git", :branch => "1.8", :shallow => false

  bottle do
    sha256 "09462a735f9f8e1ca8f4a121e5d226d72832f05fd64b8cc55e99235ce7e70f08" => :high_sierra
    sha256 "b8de6b1d4ad7acaef9c80c6ae68cab15eaad984e2905e3d8f3045c0b7510687e" => :sierra
    sha256 "aaa307ec10e11975e8d473e5488623f7c0871e75922d5e7ff2c8eb8b5603220b" => :el_capitan
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
