class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/1.15.0.tar.gz"
  sha256 "e9b4d467e67692708f6a2cfc78372156f3945ba5fdd21a3c799fa2c29b150563"
  license "Apache-2.0"
  head "https://github.com/apple/swift-protobuf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "40ef8fa7b41ef8d444118486c2561dce57c696f6632c8ff6c881d97b9c78767f" => :big_sur
    sha256 "b9877fe48cd75939960232fa8fdb0a2c6a993c6e39c9d50ca9f6276dc7dada81" => :arm64_big_sur
    sha256 "0bc9ae01fe8a2c6603f2a0613ee461df63d889dd416c8b8e59ea46677b6ffc39" => :catalina
    sha256 "f538eda859a0f4398126678566eb5b6c8321bb12d81d2b8663cc045053796415" => :mojave
  end

  depends_on xcode: ["8.3", :build]
  depends_on "protobuf"

  conflicts_with "protobuf-swift",
    because: "both install `protoc-gen-swift` binaries"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/protoc-gen-swift"
    doc.install "Documentation/PLUGIN.md"
  end

  test do
    (testpath/"test.proto").write <<~EOS
      syntax = "proto3";
      enum Flavor {
        CHOCOLATE = 0;
        VANILLA = 1;
      }
      message IceCreamCone {
        int32 scoops = 1;
        Flavor flavor = 2;
      }
    EOS
    system Formula["protobuf"].opt_bin/"protoc", "test.proto", "--swift_out=."
    assert_predicate testpath/"test.pb.swift", :exist?
  end
end
