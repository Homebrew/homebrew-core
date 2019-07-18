class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/1.6.0.tar.gz"
  sha256 "8ec819698efbc6181aa96184c737b34a615495a17d0ccd86634d3cddca5b6838"
  head "https://github.com/apple/swift-protobuf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a4ee0464cd6125b849b959dd8dad2047e2afea43429ff197ea9025c8c0a8f21f" => :mojave
    sha256 "251715b4b26f9df5f901a98ded52dfd0070a41a9c13cb9b59b963147307bf76b" => :high_sierra
    sha256 "95986d2602d37ae18b57565ff14f24765cea82c17d3aee26104017d3cdc4e964" => :sierra
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
