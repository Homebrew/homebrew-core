class Tarantool < Formula
  desc "In-memory database and Lua application server."
  homepage "https://tarantool.org/"
  url "https://download.tarantool.org/tarantool/1.7/src/tarantool-1.7.3.7.tar.gz"
  sha256 "6c0e1eb37eebf662a8946d990c8e79ca44c5ccc7be8e86e97d1dc334d3f90d7b"

  head "https://github.com/tarantool/tarantool.git", :branch => "1.7", :shallow => false

  bottle do
    sha256 "f45db64033c6cf2799b2af54db6bf2ccc75881c2f62a6ff5ce71a3b479d4adfe" => :sierra
    sha256 "44933b913e237ab36e5ef05035a9f8d5709638a80e5e3cdece072b3a1272ae88" => :el_capitan
    sha256 "9d6e5904fade724e484c8ff03b5f1969cbafbea1a3ed51c7b3f5ade6b36d98f1" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "openssl"
  depends_on "readline"

  def install
    args = std_cmake_args

    args << "-DCMAKE_INSTALL_MANDIR=#{doc}"
    args << "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}"
    args << "-DCMAKE_INSTALL_LOCALSTATEDIR=#{var}"
    args << "-DENABLE_DIST=ON"
    args << "-DOPENSSL_ROOT_DIR=#{Formula["openssl"].opt_prefix}"
    args << "-DREADLINE_ROOT=#{Formula["readline"].opt_prefix}"

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
