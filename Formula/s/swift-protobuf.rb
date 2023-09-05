class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/1.23.0.tar.gz"
  sha256 "13b199198efc7360085680a7a678d35477df235b76d5a6da79ccbb929bda56ee"
  license "Apache-2.0"
  head "https://github.com/apple/swift-protobuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9cf901f7261a0caf3e9955e8c188af17ecce5524a8ad8449e795c02df824325d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41497677eb325c4cf69aacd4a3e6a5449e54a719be22cfa4b4f37b1f7392ec60"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41707f45996f15262d3a7cc9052a22f13f644e2b35a3e849ce1a8e22ea8358fd"
    sha256 cellar: :any_skip_relocation, ventura:        "b4e709b28a0ad11c05d78fca4413ba2659c4d8ebc1e3886ca7c291ffade59a85"
    sha256 cellar: :any_skip_relocation, monterey:       "0c917917de7ad44cfdd6b9634d984fce07789ac1168f2cfe5fa7d26a4c237017"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2c0bf671c1cbf830d7ab78559ee8d8756e82b8f9684a124020c30a617e050e1"
    sha256                               x86_64_linux:   "5e6545531fb8a7b0e6198819beaefe7f3c8eb22cd18340faa1baff34c4bd90cd"
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
