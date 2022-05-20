class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/1.19.0.tar.gz"
  sha256 "f057930b9dbd17abeaaceaa45e9f8b3e87188c05211710563d2311b9edf490aa"
  license "Apache-2.0"
  head "https://github.com/apple/swift-protobuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "162f55cf00aaa89d9952feff713ce918d7d24917f1abc033c52dda6fcbabbcd7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ef362651f4151963a0aaa4c027f4a99aed89e3ba26bc8137c783150d3807b55"
    sha256 cellar: :any_skip_relocation, monterey:       "5d71a9a9fb687cc6b27113b8f8afbfa3dcdd3b25583460b92b503c31ead6b1b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "db70e4ba5b715c05d422814f027b8a61995c7ab6fef79e108b7d70d006ee591d"
    sha256 cellar: :any_skip_relocation, catalina:       "8a49fbfb63668dbe460488ce0c28ab624a9f604ead58aa958fb45b69db2c6a6f"
    sha256                               x86_64_linux:   "b8f0227011218a882befd20e7b7d1fc254e32b09e35de368e6ae567d95f007cd"
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
