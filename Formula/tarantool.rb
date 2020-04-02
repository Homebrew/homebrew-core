class Tarantool < Formula
  desc "In-memory database and Lua application server"
  homepage "https://tarantool.org/"
  url "https://download.tarantool.org/tarantool/2.3/src/tarantool-2.3.1.1.tar.gz"
  sha256 "5ea7e5dba6300cdcc0769b0cd7ce46848dc398187159a24ffaea5057bea73aa2"
  revision 1
  head "https://github.com/tarantool/tarantool.git", :branch => "2.3", :shallow => false

  bottle do
    cellar :any
    sha256 "5a0606dea3b83bea8f39644a3d4562d1f1286f29ba3a4e66be25259b84de0b58" => :catalina
    sha256 "d73e46173f0ddf6b7e2782d153599d2e9f07027889a2fc59f0479644190291f7" => :mojave
    sha256 "f2921e158f4204f535440bf1ad8d7e8d42c07b3964092851d0efeb888aa59293" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "icu4c"
  depends_on "openssl@1.1"
  depends_on "readline"

  def install
    sdk = MacOS::CLT.installed? ? "" : MacOS.sdk_path

    # Necessary for luajit to build on macOS Mojave (see luajit formula)
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    args = std_cmake_args
    args << "-DCMAKE_INSTALL_MANDIR=#{doc}"
    args << "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}"
    args << "-DCMAKE_INSTALL_LOCALSTATEDIR=#{var}"
    args << "-DENABLE_DIST=ON"
    args << "-DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}"
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
