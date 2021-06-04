class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/1.17.0.tar.gz"
  sha256 "f3e839bb445edcbf1aeb52ce6f24ae52a16cf5c45efb1721633b4d0c73ecc537"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apple/swift-protobuf.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "341ed4f82143e163938c81c909d339855450400fa7f52cabb7fe76533ea01c87"
    sha256 cellar: :any_skip_relocation, big_sur:       "266cecf8f26476cc552225d6c1eebbb39535c810b7cdd16ce67eb39bac34cf79"
    sha256 cellar: :any_skip_relocation, catalina:      "868901e305a317939313dc1c2c2b512a554ed41ea2fb731efc541188591fdaeb"
    sha256 cellar: :any_skip_relocation, mojave:        "879fe5364121784c787d3be0bae22bdbf4406c8891d050cda2b8d9b9d2f5b455"
  end

  depends_on xcode: ["8.3", :build]
  depends_on "protobuf"

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
