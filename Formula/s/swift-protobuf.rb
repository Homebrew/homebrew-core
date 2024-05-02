class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/refs/tags/1.26.0.tar.gz"
  sha256 "25224376205a54bb719fe7d97aeb9d8f5219c7ef668f426a5dab2da7db992842"
  license "Apache-2.0"
  head "https://github.com/apple/swift-protobuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "174794e57512aac4a92d68ea91989eb9aeab264a952ec5d6ae2bba1ff6f9cca2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fafd73d335522c3a6821631f17a402d05db2b519904d7fd2794860c33e6858b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6f11c2036820987cf21813489eb22d959a46a99edfe5d3ef8145ed8766ee579"
    sha256 cellar: :any_skip_relocation, sonoma:         "11ff57ba83326571ccd42613a4a3ec638f5ca76a0f573eab1a52513da44208a5"
    sha256 cellar: :any_skip_relocation, ventura:        "605ee5014865c131fe3cf84a2bac141ac38220774749943a2a99a62847407777"
    sha256 cellar: :any_skip_relocation, monterey:       "659734c95371bff617fc0c3cd83f3064e560a2d53511b90f91f071e131c02ae1"
    sha256                               x86_64_linux:   "f513e99eca9911a1795dd926532d6a281c77cff94326ec57fa9fc441ff5ab81b"
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
