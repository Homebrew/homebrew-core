class Serdes < Formula
  desc "Schema-based serializer/deserializer C/C++ library with support for Avro and the Confluent Platform Schema Registry"
  homepage "https://github.com/confluentinc/libserdes"
  url "https://github.com/confluentinc/libserdes.git",
  :tag      => "v5.3.1"

  bottle do
    cellar :any
  end

  depends_on "curl"
  depends_on "avro-c"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

end
