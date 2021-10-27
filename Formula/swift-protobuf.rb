class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/1.18.0.tar.gz"
  sha256 "e7afc0d07e0d8970269ca04948cec36ecac85f4526c29ff2c211fc016bde27d6"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apple/swift-protobuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a5c84ddd827e0126c615d5dd274beda8d257d1bf63b27ceb3c615bd12eaa0ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a1c709bf25fa4c7d02cdbcb5ff481fa8d0ba37897a03c6f1a58b1d38248bc32"
    sha256 cellar: :any_skip_relocation, monterey:       "81496b6246fa89194d7ffa490ae303332ffc6dcd2f2efd7786a25a3a82202651"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae0390c500b0ca6e9665f23c8e4a0224f790ed232184d530bf9c8c772f068f89"
    sha256 cellar: :any_skip_relocation, catalina:       "172f3e61a551548eeb7d93ae2fb001b0b99c38cc440c905aa72d907037730a4e"
    sha256                               x86_64_linux:   "0b7c5288ec35491c7a435cd5cae5deb553221c6ee1d50946af12271f9f264fbe"
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
