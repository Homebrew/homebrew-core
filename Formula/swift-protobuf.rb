class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/1.16.0.tar.gz"
  sha256 "a8c06b3fb05b18d74bd63151f0074904e8223cbe8217d0c6cbb4fba470dfb766"
  license "Apache-2.0"
  head "https://github.com/apple/swift-protobuf.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bfce79a8f87aa3068fdd3dd9e94741063726296219ca6f94e4f9fe6bff2fd8d9"
    sha256 cellar: :any_skip_relocation, big_sur:       "ba9c25b3633a182124ad138ea6c804c200e2d18e0a85705fdbce9228f34d09b8"
    sha256 cellar: :any_skip_relocation, catalina:      "4fdd4cd86dc6313637f3ddb8d312f41cf69dd942eaf01aba8bda0ee8db470740"
    sha256 cellar: :any_skip_relocation, mojave:        "3ee13d668071884c84516f7d4e3c1fa980e5b70655aea7c46f68b7c95d68efc4"
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
