class Tarantool < Formula
  desc "In-memory database and Lua application server."
  homepage "https://tarantool.org/"
  url "http://download.tarantool.org/tarantool/1.7/src/tarantool-1.7.1.401.tar.gz"
  version "1.7.1-401"
  sha256 "615a92e481fdd6231a4581d2f1d2f9b22e7bcb9936bbfd19da12a323a7c91fe2"
  head "https://github.com/tarantool/tarantool.git", branch: "1.8", shallow: false

  bottle do
    sha256 "47f9dbb5080b9fad24d8e4bc34d5c5e6decb386e7050aafceb47f1ba2162bfe0" => :el_capitan
    sha256 "d442d7392b63449fe581e4722d46487db7a84a8ac281983230263a92246e76a5" => :yosemite
    sha256 "0e2127a031d1e0993a1cde763d6ee5680d06f907d8e8d9529a5d22b42e0d2f17" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "openssl"
  depends_on "readline"

  def install
    args = std_cmake_args

    # Fix "dyld: lazy symbol binding failed: Symbol not found: _clock_gettime"
    # Reported 19 Sep 2016 https://github.com/tarantool/tarantool/issues/1777
    if MacOS.version == "10.11" && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      args << "-DHAVE_CLOCK_GETTIME:INTERNAL=0"
      inreplace "src/trivia/util.h", "#ifndef HAVE_CLOCK_GETTIME",
                                     "#ifdef UNDEFINED_GIBBERISH"
    end

    args << "-DCMAKE_INSTALL_MANDIR=#{doc}"
    args << "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}"
    args << "-DCMAKE_INSTALL_LOCALSTATEDIR=#{var}"
    args << "-DENABLE_DIST=ON"
    args << "-DOPENSSL_ROOT_DIR=#{Formula["openssl"].opt_prefix}"

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
    (testpath/"test.lua").write <<-EOS.undent
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
