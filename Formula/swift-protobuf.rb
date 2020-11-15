class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/1.13.0.tar.gz"
  sha256 "7d9b391f738e7672b670cc194a74143a6baaea82452b486f2e10a8208fe1cdb4"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apple/swift-protobuf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "de56a507e0a0e52a42f72f56a133d114e085bd88615cd7c9f329d9b2f9d7e7d8" => :big_sur
    sha256 "14695e384c095925622007608c2c1d40e586ac983772bb001008618ce499b8d7" => :catalina
    sha256 "ac5c0588cd9d60548a2578ff51a755ee8f3633f09e5bc7a14c45365f49ef9f11" => :mojave
    sha256 "05c6eea1693e19cf2d950711a4d84464aff0951d67f76d6f583641e81097097c" => :high_sierra
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
