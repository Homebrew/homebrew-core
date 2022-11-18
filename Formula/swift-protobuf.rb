class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/1.20.3.tar.gz"
  sha256 "bff1a5940b5839b9a2f41b1cc308439abdd25d2435e7a36efb27babbb0d8d96d"
  license "Apache-2.0"
  head "https://github.com/apple/swift-protobuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1a1bfb300bde92ebdeeffe944519b47b3c1f87782f94abcf732cc6337c83d6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2942e98393b832e111f497f0307519cb804da44805ea808871257a985c5e828"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2edda1eae560c71c5af63c40b4c1f5db4f4519f19e8c687a1164a68824cf79d"
    sha256 cellar: :any_skip_relocation, ventura:        "efd376ffbdafd5103eb3b30cf344ed026db5025eb37b79fc09d8091be96cc0b9"
    sha256 cellar: :any_skip_relocation, monterey:       "9f50576e1878a6223afcf1070a6cf41e6da512a2465ff2aad2b53344220a7cf4"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d8d11284d2023a21d5abc0557892388862c4e59e7bb412b5306462dfa34ed80"
    sha256 cellar: :any_skip_relocation, catalina:       "fec03e634072c0d7dcb80427bafbaa9709104f035d73c2ab5c72323d462106d7"
    sha256                               x86_64_linux:   "e03b4561a10795235ab9459391fed4599933bbd0c21dd4308f1a0c98d83a8374"
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
