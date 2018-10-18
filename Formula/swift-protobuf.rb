class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/1.2.0.tar.gz"
  sha256 "5a5a38c8a18227a2771649fb23bb9d38438c466056e1d3d9595ae1ddf97b2d2c"
  head "https://github.com/apple/swift-protobuf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b77a8c0f74b9d9cb4a0bfe26b2d27c727ce813d0bbdab21acc8dafdff8fc0111" => :mojave
    sha256 "c7349ebdebe1770c48df3de7b2ee1081e4c7b83a6660e22e3eb6e1fff31f1c9f" => :high_sierra
    sha256 "7c7d801c9e271b07cab65e6a471b4a580a0301a54c2bcbdd16b3854adb67b3c4" => :sierra
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
