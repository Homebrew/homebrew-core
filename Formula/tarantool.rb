class Tarantool < Formula
  desc "In-memory database and Lua application server."
  homepage "https://tarantool.org/"
  url "https://tarantool.org/dist/1.6/tarantool-1.6.8.653.tar.gz"
  version "1.6.8-653"
  sha256 "1c7f210dfadb8660db6ddc4bb680cd167f37e93d3747d57989850eef7f17933e"
  head "https://github.com/tarantool/tarantool.git", :branch => "1.7", :shallow => false

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
