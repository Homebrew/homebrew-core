class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/1.22.1.tar.gz"
  sha256 "a1c023c2eaf393350800e3cfadbea327c48f072626df4b12f238a52eee3a0f7b"
  license "Apache-2.0"
  head "https://github.com/apple/swift-protobuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0c3ad89a86fed8f23163d4fc31a5f8652ccd21640967372685670a0d9647126"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0adf4afc0fdd0ad5e3b09f8c42df914803e4c3cb844a4e9d8b656fb81aabe03"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c4be07b3f2f920a4a15b1bc7b212ed8a48b330dc872f3783940f7e0c96d14b1"
    sha256 cellar: :any_skip_relocation, ventura:        "f353ecca6db6bd4a06bd45d62308720889d2f71cb0767a0079244301ee16fd6a"
    sha256 cellar: :any_skip_relocation, monterey:       "12fa11360a9034aadf3a63fd96bb2a30082ab9596f8a7e1449ed2d18146d2efe"
    sha256 cellar: :any_skip_relocation, big_sur:        "5072488cfef69bd220cee4327ad46d9f39bdb49c2045798d8852c71396b473e1"
    sha256                               x86_64_linux:   "2109d7354d89d9faf3f5faf0d9fdb8161f2e6e9501762070467655105fe47eda"
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
