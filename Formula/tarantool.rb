class Tarantool < Formula
  desc "In-memory database and Lua application server."
  homepage "https://tarantool.org/"
  url "https://download.tarantool.org/tarantool/1.7/src/tarantool-1.7.4.18.tar.gz"
  sha256 "5a1703190a42bac570cc1cbf9a76b62a488723db1a671db39071ed5a5a36d344"

  head "https://github.com/tarantool/tarantool.git", :branch => "1.8", :shallow => false

  bottle do
    sha256 "872054634b828db330728218df90b0bb3ecb98c7a4d40132e092d1cbc85bc4fd" => :sierra
    sha256 "f4bfdecb75a6ddc4e680ea5d4f6b9dca62e40fa8ac2e3c4fea0c36250aaeb584" => :el_capitan
    sha256 "eff95199b02b2de5a93173738d42e0cb22aa27f71712db92428dbcf427c050bb" => :yosemite
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
