class Servus < Formula
  desc "Library and Utilities for zeroconf networking"
  homepage "https://github.com/HBPVIS/Servus"
  url "https://github.com/HBPVIS/Servus.git",
      :tag => "1.5.1",
      :revision => "eee576548a05292179f4892d48b97108d8ed07c0"

  bottle do
    cellar :any
    sha256 "65daafc6c169de45d7579425522250c81e4e9f8f83aef66b58d43d4426826248" => :mojave
    sha256 "fc9303986cd2dda58a7ed71e96273eef4517120b4e8b32f2956f672f3125e312" => :high_sierra
    sha256 "6946b4f5b7151f94cdb6e75ae47fda08a1da867f5690e757ee9d82875836905a" => :sierra
    sha256 "39e8d21f40ecf08f3bf68e565648c9b94e4eb5d1acda854d8ff58676dce9a7dc" => :el_capitan
    sha256 "3f23b83c09997e5e51b0089b7d2fad4ee8d7527fe29633cb6551a239acff59d7" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    # Embed "serializeable" test from the servus 1.5.0 source
    (testpath/"test.cpp").write <<~EOS
      #define BOOST_TEST_MODULE servus_serializable
      #include <boost/test/unit_test.hpp>

      #include <servus/uint128_t.h>
      #include <servus/serializable.h>

      void dummyFunction(){}

      class SerializableObject : public servus::Serializable
      {
      public:
          std::string getTypeName() const final { return "test::serializable"; }

          servus::uint128_t getTypeIdentifier() const final
          {
              return servus::make_uint128( getTypeName( ));
          }

      private:
          bool _fromBinary( const void*, const size_t ) { return true; }
          bool _fromJSON( const std::string& ) { return true; }
      };


      BOOST_AUTO_TEST_CASE(serializable_types)
      {
          SerializableObject obj;
          BOOST_CHECK_EQUAL( obj.getTypeName(), "test::serializable" );
          BOOST_CHECK_EQUAL( servus::make_uint128( obj.getTypeName( )),
                             obj.getTypeIdentifier( ));
          BOOST_CHECK_EQUAL( obj.getSchema(), std::string( ));
      }

      BOOST_AUTO_TEST_CASE(serializable_registerSerialize)
      {
          SerializableObject obj;
          servus::Serializable::SerializeCallback callback( dummyFunction );

          obj.registerSerializeCallback( callback );
          BOOST_CHECK_THROW( obj.registerSerializeCallback( callback ),
                             std::runtime_error ); // callback already registered

          BOOST_CHECK_NO_THROW( obj.registerSerializeCallback(
              servus::Serializable::SerializeCallback( )));
          BOOST_CHECK_NO_THROW( obj.registerSerializeCallback( callback ));

          BOOST_CHECK_THROW( obj.registerSerializeCallback( callback ),
                             std::runtime_error ); // callback already registered
      }

      BOOST_AUTO_TEST_CASE(serializable_registerDeserialized)
      {
          SerializableObject obj;
          servus::Serializable::DeserializedCallback callback( dummyFunction );

          obj.registerDeserializedCallback( callback );
          BOOST_CHECK_THROW( obj.registerDeserializedCallback( callback ),
                             std::runtime_error ); // callback already registered

          BOOST_CHECK_NO_THROW( obj.registerDeserializedCallback(
              servus::Serializable::DeserializedCallback( )));
          BOOST_CHECK_NO_THROW( obj.registerDeserializedCallback( callback ));

          BOOST_CHECK_THROW( obj.registerDeserializedCallback( callback ),
                             std::runtime_error ); // callback already registered
      }

      BOOST_AUTO_TEST_CASE(serializable_binary)
      {
          SerializableObject obj;

          // fromBinary implemented
          BOOST_CHECK_NO_THROW( obj.fromBinary( new float[3], 3 ));

          // default toBinary (unimplemented)
          BOOST_CHECK_THROW( obj.toBinary(), std::runtime_error );
      }

      BOOST_AUTO_TEST_CASE(serializable_json)
      {
          SerializableObject obj;

          // fromJson implemented
          BOOST_CHECK_NO_THROW( obj.fromJSON( std::string( "testing..." )));

          // default toJson (unimplemented)
          BOOST_CHECK_THROW( obj.toJSON(), std::runtime_error );
      }
    EOS
    system ENV.cxx, "-lServus", "-DBOOST_TEST_DYN_LINK", "-lboost_unit_test_framework-mt", "-std=gnu++11", "test.cpp", "-o", "test"
    system "./test"
  end
end
