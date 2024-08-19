class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/refs/tags/1.27.1.tar.gz"
  sha256 "155e17578c680f8127540228570d2d74fddf37946b6a25ede76b857bf3ede722"
  license "Apache-2.0"
  head "https://github.com/apple/swift-protobuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bee3f666a6f3e5e777080d5b2a52b9a0fd222ddda404e37502b3c011816586a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5bf2e3ba488b9b1c70bc0e8cd171f877462eb92d399d81c8df19da3b18b15e79"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2c9967cbe3faa5e661813c4aa2b69f71be2e81690f9dde419ea02d6417e4b78"
    sha256 cellar: :any_skip_relocation, ventura:       "b77a298f6fb919df816ee5f3dec818979f728512d37667e0f5cc1de6145d2a43"
    sha256                               x86_64_linux:  "f2e68a004e4db5315349ef5944a896c9dcef7088adbf8070e28ea6dec6441591"
  end

  depends_on xcode: ["14.3", :build]
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
