class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/1.22.0.tar.gz"
  sha256 "3ee3cc82bc33fc32d8ed709404195f692504d50d1dab345de91129745d36d48f"
  license "Apache-2.0"
  head "https://github.com/apple/swift-protobuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7451543e4e8a63a2fe8a79af44c9a2d522e835efed2a21d8713b7588d60034c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac14705b29e7d3a2917c9824a48c6095a1a99171d551beaf6523e75b31c4f18a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7b8250a76da2574634aa3dbfd63f9ee0263845217ce0c24d1d58e12d0582c7e"
    sha256 cellar: :any_skip_relocation, ventura:        "3fbde1f1dc9f69367b67a843a7c4d6f00ff5bd2b273b8d0e1e3f137019ea8074"
    sha256 cellar: :any_skip_relocation, monterey:       "4ba89f3dece4f264d21ec853baefbe52fbc2ecc2ef2e9cb87f954b035653a4c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf10fa8d8de07bd8974d2490e97392314b8b6252fb19fd9992111ed493dceb78"
    sha256                               x86_64_linux:   "6a2bebb98f47574410976ea347c319a25df62038fe53828a59930084ca33c307"
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
