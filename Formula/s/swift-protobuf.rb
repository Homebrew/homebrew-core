class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/1.24.0.tar.gz"
  sha256 "9ddba59e6361d9fa8077149b8142861d04513f744b31aa2458f26338977a4d21"
  license "Apache-2.0"
  head "https://github.com/apple/swift-protobuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "197c9828ec145a354296428aa432614875e2c97e98a58a7d2649a678f4e7b652"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e09b6bec9c4d7e8e1520a6575df83b9688e567061a92c0e56ced1f6a5388752"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8f65d271940d82a8af8dafa4ca580eb98472f7780118796863590146e01c2e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "4170a59f8f6718f0a3cd20f0d07391e55824998121c35ed8f26495fc1990b266"
    sha256 cellar: :any_skip_relocation, ventura:        "6bb7207fd61eee7c3dd5d1ec262baf32aed96fb7a02dd59694f248536ea8bb8e"
    sha256 cellar: :any_skip_relocation, monterey:       "35442ca4141c56489cc8a29ccd01b5f21b73f89061ae2b77be0ee8d6aaca19f2"
    sha256                               x86_64_linux:   "bd79275cc80c52b5dc888e1e9a193ce10e071e0384e7e5f1c6b203af5b00ba4b"
  end

  depends_on xcode: ["8.3", :build]
  depends_on "protobuf"

  uses_from_macos "swift"

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
