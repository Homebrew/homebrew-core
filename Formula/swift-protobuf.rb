class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/1.8.0.tar.gz"
  sha256 "73e1d2e749db23f8d39636a462a463926225e390a7220a65b28fa173ac831a46"
  head "https://github.com/apple/swift-protobuf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a14c2a73a4fe5e7ee6d630dcaa1d45b991d33a617024b5c11c9dc5cb4e4e8cc" => :catalina
    sha256 "2b77ee4ea2337d20fa940cc73947439d779dfd8e5e43a4c0dfb8485693def68f" => :mojave
    sha256 "e1511be6caeed3f9a63d831216170fff5f7685c83815f8d3481a2e32ffea2bb2" => :high_sierra
  end

  depends_on :xcode => ["8.3", :build]
  depends_on "protobuf"

  conflicts_with "protobuf-swift",
    :because => "both install `protoc-gen-swift` binaries"

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
