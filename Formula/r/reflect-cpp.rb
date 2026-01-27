class ReflectCpp < Formula
  desc "C++20 library for data (de)serialization using reflection"
  homepage "https://rfl.getml.com/"
  url "https://github.com/getml/reflect-cpp/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "9c5650d7ef0ab2b0ff617095280c641e6d770d9efc62dc04d86bb6ea56b55130"
  license "MIT"

  depends_on "cmake" => [:build, :test]
  depends_on "apache-arrow"
  depends_on "capnp"
  depends_on "ctre" => :no_linkage
  depends_on "flatbuffers"
  depends_on "mongo-c-driver"
  depends_on "msgpack"
  depends_on "pugixml"
  depends_on "tomlplusplus"
  depends_on "yaml-cpp"
  depends_on "yyjson"

  def install
    # Fix package and target names for mongo-c-driver, apache-arrow, and msgpack.
    # Upstream PR: https://github.com/getml/reflect-cpp/pull/568
    inreplace "CMakeLists.txt" do |s|
      s.gsub! "bson-1.0", "bson"
      s.gsub! "$<IF:$<TARGET_EXISTS:mongo::bson_static>,mongo::bson_static,mongo::bson_shared>", "bson::shared"
      s.gsub! "find_package(Arrow CONFIG REQUIRED)", "find_package(Arrow REQUIRED)\nfind_package(Parquet REQUIRED)"
      s.gsub! '"arrow::arrow"', "Arrow::arrow_shared Parquet::parquet_shared"
      s.gsub!(/PUBLIC \$<IF:\$<TARGET_EXISTS:msgpack-c.+?>>\)/, "PUBLIC msgpack-c)")
    end
    inreplace "reflectcpp-config.cmake.in", "bson-1.0", "bson"

    args = %w[
      -DREFLECTCPP_ALL_FORMATS=ON
      -DREFLECTCPP_AVRO=OFF
      -DREFLECTCPP_CBOR=OFF
      -DREFLECTCPP_UBJSON=OFF
      -DREFLECTCPP_USE_BUNDLED_DEPENDENCIES=OFF
      -DREFLECTCPP_USE_VCPKG=OFF
      -DBUILD_SHARED_LIBS=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Install a static library archive too
    inreplace "CMakeLists.txt" do |s|
      s.gsub! "bson::shared", "bson::static"
      s.gsub! "Arrow::arrow_shared", "Arrow::arrow_static"
      s.gsub! "Parquet::parquet_shared", "Parquet::parquet_static"
      s.gsub! "PUBLIC msgpack-c)", "PUBLIC msgpack-c-static)"
    end
    args.pop
    system "cmake", "-S", ".", "-B", "build_static", *args, *std_cmake_args
    system "cmake", "--build", "build_static"
    lib.install buildpath/"build_static/libreflectcpp.a"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.12)
      project(FormulaTest CXX)

      set(CMAKE_NO_SYSTEM_FROM_IMPORTED ON)
      find_package(reflectcpp REQUIRED)

      add_executable(test test.c++)
      target_compile_features(test PRIVATE cxx_std_20)
      target_link_libraries(test PRIVATE reflectcpp::reflectcpp)
    CMAKE

    # A test that covers all predifined formats supported by the built library
    (testpath/"test.c++").write <<~'CXX'
      #include <rfl/bson.hpp>
      #include <rfl/capnproto.hpp>
      #include <rfl/csv.hpp>
      #include <rfl/flexbuf.hpp>
      #include <rfl/json.hpp>
      #include <rfl/msgpack.hpp>
      #include <rfl/parquet.hpp>
      #include <rfl/toml.hpp>
      #include <rfl/xml.hpp>
      #include <rfl/yaml.hpp>

      #include <cassert>
      #include <string>
      #include <vector>

      struct Person { std::string name; int age; };
      using Collection = std::vector<Person>;

      static bool operator==(const Person& lhs, const Person& rhs)
      {
        return lhs.name == rhs.name && lhs.age == rhs.age;
      }

      int main()
      {
        const auto bob = Person{.name = "Bob", .age = 30};
        const auto people = Collection{bob};

        const auto csv  = rfl::csv::write(people);
        assert("\"name\",\"age\"\n\"Bob\",30\n" == csv);
        assert(bob == rfl::csv::read<Collection>(csv).value().front());

        const auto json = rfl::json::write(bob);
        assert(R"({"name":"Bob","age":30})" == json);
        assert(bob == rfl::json::read<Person>(json).value());

        const auto yaml = rfl::yaml::write(bob);
        assert("name: Bob\nage: 30" == yaml);
        assert(bob == rfl::yaml::read<Person>(yaml).value());

        assert(bob == rfl::bson::read<Person>(rfl::bson::write(bob)).value());
        assert(bob == rfl::capnproto::read<Person>(rfl::capnproto::write(bob)).value());
        assert(bob == rfl::flexbuf::read<Person>(rfl::flexbuf::write(bob)).value());
        assert(bob == rfl::msgpack::read<Person>(rfl::msgpack::write(bob)).value());
        assert(bob == rfl::parquet::read<Collection>(rfl::parquet::write(people)).value().front());
        assert(bob == rfl::toml::read<Person>(rfl::toml::write(bob)).value());
        assert(bob == rfl::xml::read<Person>(rfl::xml::write(bob)).value());
      }
    CXX

    system "cmake", "."
    system "cmake", "--build", "."
    system "./test"
  end
end
