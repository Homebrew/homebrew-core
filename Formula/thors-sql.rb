class ThorsSql < Formula
  desc "SQL library for C++14"
  homepage "https://github.com/Loki-Astari/ThorsSQL"
  url "https://github.com/Loki-Astari/ThorsSQL.git",
      :tag => "1.5.6",
      :revision => "2da4ab817a4f45f0d3f8a7bf7ad0fc455031f0f6"

  depends_on "mysql" => :build
  depends_on "openssl"

  needs :cxx14

  def install
    ENV["COV"] = "gcov"
    system "mysql.server", "start"
    system "init/testdb"
    system "./configure", "--disable-vera",
                          "--prefix=#{prefix}"
    system "make", "-j", "1"
    system "make", "-j", "1", "install"
    system "mysql.server", "stop"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "ThorSQL/Connection.h"
      #include "ThorSQL/Statement.h"

      int main()
      {
          namespace SQL = ThorsAnvil::SQL;

          std::map<std::string, std::string>      options {{"default-auth", "mysql_native_password"}};
          SQL::Connection   connection("mysql://localhost", "test", "testPassword", "test", options);
          SQL::Statement    statement(connection, "SELECT Age FROM People");

          int sumAge = 0;
          int count  = 0;
          statement.execute([&sumAge, &count](int age) {
            sumAge  += age;
            ++count;
          });

          if (count != 2 || sumAge != 61) {
            std::cerr << "Fail";
            return 1;
          }
          std::cerr << "OK";
          return 0;
      }
    EOS
    system "mysql.server", "start"
    system ENV.cxx, "-std=c++14", "test.cpp", "-o", "test",
           "-I#{include}", "-L#{lib}", "-lThorMySQL17", "-lThorSQL17"
    system "./test"
    system "mysql.server", "stop"
  end
end
