class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/1.18.0.tar.gz"
  sha256 "e7afc0d07e0d8970269ca04948cec36ecac85f4526c29ff2c211fc016bde27d6"
  license "Apache-2.0"
  head "https://github.com/apple/swift-protobuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "257749f6c744543b033cb0de0cabdd26d995706e664cbc890c849f4833c3bfaf"
    sha256 cellar: :any_skip_relocation, big_sur:       "1b4c14e6963df4429b639c7155304db9a41f91656f4fc5e7cf895d504b59e134"
    sha256 cellar: :any_skip_relocation, catalina:      "112b03dc9ea6758efd1fcfbeec17a4d50eb7fe3207e958f007088674111d3239"
    sha256 cellar: :any_skip_relocation, mojave:        "8120679896d3ef9532185791884d4b0a98e676c25e01b1eca6bf0c895d510899"
    sha256                               x86_64_linux:  "0fa6e6415a14b0d9bba21a68ffb721cf6d9e42ec422c2a1ec76a9497d49a8e70"
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
