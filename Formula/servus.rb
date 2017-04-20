class Servus < Formula
  desc "Library and Utilities for zeroconf networking"
  homepage "https://github.com/HBPVIS/Servus"
  url "https://github.com/HBPVIS/Servus/archive/1.5.0.tar.gz"
  sha256 "42fb9c060f17f040ad3c7563f5e87c89f5a221a5aa7da21384fc26b9c725ecc8"
  revision 1

  bottle do
    cellar :any
    sha256 "e9a959eeaacec3a8b99607f71fbf8bc900d96d5949e5329e32909e83d39b4c18" => :sierra
    sha256 "7fbf4c4b8d9524e8b76ba6602f46f42a9e2cdc3605c1a482168ac5689a4fd707" => :el_capitan
    sha256 "206d176deea834d37313413c98c932b2063e8feab5d485c8b74ff264c66c5914" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    # Embed "serializeable" test from the servus 1.5.0 source
    (testpath/"test.cpp").write <<-EOS.undent
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
