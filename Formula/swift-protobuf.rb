class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/1.3.1.tar.gz"
  sha256 "ff0049f7e10faff918190a321dddc0084224cb3687f4e704022c57a52094bbed"
  head "https://github.com/apple/swift-protobuf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "501a799caef274af229e39bad393014cfec3429fccb86e7d91f068454eca50d1" => :mojave
    sha256 "0628445a3182b2ad42dd5164d1306a61dd5d990408933eb205a4e20a77da3ef2" => :high_sierra
    sha256 "bf88c712c2db5eb307c79104347638ebd302b5bd6d21e8809bf4505361eaf2db" => :sierra
  end

  depends_on :xcode => ["8.3", :build]
  depends_on "protobuf"

  conflicts_with "protobuf-swift",
    :because => "both install `protoc-gen-swift` binaries"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "-Xswiftc",
           "-static-stdlib"
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
