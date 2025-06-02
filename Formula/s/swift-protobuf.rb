class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/refs/tags/1.30.0.tar.gz"
  sha256 "fbcdcca3aae7ca11756d4d183cb7b886c0e95bea4f516352f3a6aad77270b091"
  license "Apache-2.0"
  head "https://github.com/apple/swift-protobuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a479553914a58e9b3d2b314f2ce472b8e894a3eb601846aa14d58746915b6fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b32261300103bdd00e8a246c93d80b73438012b6f6be56eb4227fd9cdd98c36"
    sha256 cellar: :any_skip_relocation, sonoma:        "816685a49020e4ba9791d74b0e1b750919ac81d2a211aa1d5a876cb979ad8c96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a74d95bf93b9cb5d1b27181ee129420640337811335a01bc89b70c4c95ea87d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b8a216b4df9f94da882786690aa57c1a4e745526dc27bf2adf3d0e007d935af"
  end

  depends_on xcode: ["15.3", :build]
  depends_on "protobuf"

  uses_from_macos "swift" => :build

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "-c", "release"
    bin.install ".build/release/protoc-gen-swift"
    doc.install "Documentation/PLUGIN.md"
  end

  test do
    (testpath/"test.proto").write <<~PROTO
      syntax = "proto3";
      enum Flavor {
        CHOCOLATE = 0;
        VANILLA = 1;
      }
      message IceCreamCone {
        int32 scoops = 1;
        Flavor flavor = 2;
      }
    PROTO
    system Formula["protobuf"].opt_bin/"protoc", "test.proto", "--swift_out=."
    assert_path_exists testpath/"test.pb.swift"
  end
end
