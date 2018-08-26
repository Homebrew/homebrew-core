class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/1.1.1.tar.gz"
  sha256 "1eb67bb987c7eb8834b1792f5e47a42c53063ef2b8eb073505c68530e20e85c2"
  head "https://github.com/apple/swift-protobuf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "13714bfef5685b0fccc9727b4c2500feea80c954d2f772d35a19989d6f6f4987" => :mojave
    sha256 "8a6e85b4052ea9ebb8cdeb1ce6bbb159ccccd0cd835e6f14e8f312f9d74d4569" => :high_sierra
    sha256 "cb7f2ae9cd1e9d839b375776cc73ec5d81a7b349b85e58530039e2cec737b139" => :sierra
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
