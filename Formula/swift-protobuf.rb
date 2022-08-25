class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/1.20.0.tar.gz"
  sha256 "a41214ecd30b81a95a46522ef67bf5420103e7dca5df1c85e85960b9e7459d88"
  license "Apache-2.0"
  head "https://github.com/apple/swift-protobuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e11faa3b0621ed3dfaf4fe32a324d281a0e2043fe0b8312097c6e228b9104f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9fc235e8842717be7464dc5b525eb05d25e631b595b5b2e854ee3b482634391e"
    sha256 cellar: :any_skip_relocation, monterey:       "ed9f1ff4e7d2817dea1afe3d11a349f2be56a3e19a0d5cd4d660f133f8cd1a2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "e495ba9a6f2dde596dcb59649b51f5d889627a0f48ca4d6571c3c3be0f49e0b3"
    sha256 cellar: :any_skip_relocation, catalina:       "f206e9c21ef07d5ad7ee28d30c5755909126f39927f55a57de20840941b35fca"
    sha256                               x86_64_linux:   "526ede8253d5778c511371c52c0fbcc160e84c9576fce48b968aa9206b4d501a"
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
