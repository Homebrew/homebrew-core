class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/refs/tags/1.25.1.tar.gz"
  sha256 "c52d65ddc6c3242cc2c0083e1dd03f632df2e55f18c47b4b808878c4a0a5ccac"
  license "Apache-2.0"
  head "https://github.com/apple/swift-protobuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "377a0505e53aad89609bd72ea91ea26860a41cf97abca38da19d72382113602c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a533c58ce3229bf998ba0b4959085525d3845b65971908eb2259b1cf8ac2716"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6a07236ed98a9b86834060835d8a3b6faaf60f16e1107c36178d27d9d17b94b"
    sha256 cellar: :any_skip_relocation, sonoma:         "a186fc49c3488b7e63f5cad349e80b7bbcc1ddf7df98cb73e9c5109f924d26b8"
    sha256 cellar: :any_skip_relocation, ventura:        "8dc83b6bdb58a147f4d48f41fd28855b5d3d090a4d440e312eac7ed387fa63db"
    sha256 cellar: :any_skip_relocation, monterey:       "e4e183c4e189a3cc1e3d399d209f4788375fb7c651e646a7846160d0cbf47449"
    sha256                               x86_64_linux:   "033f71de9cae4aa87e6e1693b23c37ca0223694c2413814df18fb4bc199917ba"
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
