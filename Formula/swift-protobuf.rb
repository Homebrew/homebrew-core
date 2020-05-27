class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/1.9.0.tar.gz"
  sha256 "2937ddb4404ea596b4e09a1d25d00a59dc78842abe1bd5389c75a464f7172b2f"
  head "https://github.com/apple/swift-protobuf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f2f73ecf20befa1b00ee14bf5ac9be043ca75d051733c23ee80714406e057d3" => :catalina
    sha256 "f1bf3b9a3cafa51fca852868c2362171a67cb73f48a9f984bc161efd7d451e8e" => :mojave
    sha256 "45df1e5f49d254d4855302cb0c95b4f326b441266545dd4e4d73de4d73bc0a9b" => :high_sierra
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
