class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  # We use a git checkout as swift needs to find submodule files specified
  # in Package.swift even though they aren't built for `protoc-gen-swift`
  url "https://github.com/apple/swift-protobuf.git",
      tag:      "1.35.0",
      revision: "9bbb079b69af9d66470ced85461bf13bb40becac"
  license "Apache-2.0"
  head "https://github.com/apple/swift-protobuf.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40add01b4b474eb7352cae5fb0fefbb55d54262a9c4126a979fe7e356f5f7417"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35ec08383e8dcd046248b2c17ad0044e991e3a63dba3d6670e95e467120ba997"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fde52b87615ef6e9fffecc1bc30bd7850db5ffd14791eece49c4b465337f6ede"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4e744941eb16f181df3d71593d1cf51acf1a0a39a1ca0782cdfb3766b8acd48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5aa510a0371de3ee0b911ee09b5bc1c9a86ddf6c5b95cf588319777206bbdf6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd8c57805de55227e63778d185809741b5c702e9fd6e973e69b60e2a5e7427ee"
  end

  depends_on xcode: ["15.3", :build]
  depends_on "protobuf"

  uses_from_macos "swift" => :build

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "-c", "release", "--product", "protoc-gen-swift"
    bin.install ".build/release/protoc-gen-swift"
    doc.install "Documentation/PLUGIN.md"
  end

  test do
    (testpath/"test.proto").write <<~PROTO
      syntax = "proto3";
      enum Flavor {
        CHOCOLATE = 0;
        VANILLA = 1;
      }
      message IceCreamCone {
        int32 scoops = 1;
        Flavor flavor = 2;
      }
    PROTO
    system Formula["protobuf"].opt_bin/"protoc", "test.proto", "--swift_out=."
    assert_path_exists testpath/"test.pb.swift"
  end
end
