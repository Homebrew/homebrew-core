class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/1.10.1.tar.gz"
  sha256 "e0b8084ad5d21fd93b34bd2df15e5e39955c57fbfe863738bbb31322e922d17f"
  license "Apache-2.0"
  head "https://github.com/apple/swift-protobuf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "44873aa3ab6e67604d301c0646b4d017b0c1a0ca9c8f4c6b62c04a77f8a47fb7" => :catalina
    sha256 "c73606c1f38daa770b5a62ce5ebf3c205ca4df474f3e0943849a7cf1dd2c8041" => :mojave
    sha256 "44f48d168540d3928208bbff73b55fbee3efa13f17e5b3a3e18eb21c40026433" => :high_sierra
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
