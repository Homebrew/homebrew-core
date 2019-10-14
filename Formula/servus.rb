class Servus < Formula
  desc "Library and Utilities for zeroconf networking"
  homepage "https://github.com/HBPVIS/Servus"
  url "https://github.com/HBPVIS/Servus.git",
      :tag      => "1.5.2",
      :revision => "170bd93dbdd6c0dd80cf4dfc5926590cc5cef5ab"

  bottle do
    cellar :any
    sha256 "e0629cca8bee46595c540c2240ed1cc599c5f676527a21f951bfc89a0335c54e" => :catalina
    sha256 "65921c797c3a2bf7953cf692dee5852de3fd6c2b2466268221a9dfcb7eab960e" => :mojave
    sha256 "763042d70e605154698d686554d26f6bab46f30200df8a8c3af9c40faeffca64" => :high_sierra
    sha256 "bcfa24ee0545c044c32391ac72d54a5151de64170c777409163c0688cd9bf671" => :sierra
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
    system ENV.cxx, "-L#{lib}", "-lServus", "-DBOOST_TEST_DYN_LINK",
                    "-L#{Formula["boost"].opt_lib}",
                    "-lboost_unit_test_framework-mt",
                    "-std=gnu++11", "test.cpp", "-o", "test"
    system "./test"
  end
end
