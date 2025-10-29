class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/refs/tags/1.33.2.tar.gz"
  sha256 "341dd55b57fdcd49769fa4b7fbe02b8b2176c2ab27d077824921fb084147d488"
  license "Apache-2.0"
  head "https://github.com/apple/swift-protobuf.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ebc235b0f54c194ed6734c85755cce7f8a219029008703bd32072947151a8b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "984280f0c66e09d2bcc2f73e81e53c9e1788124e3f11c3f33695140f69462e5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e28d046fd59118fef7ae9d908d18f019fe36817b28737039b7c937d67065813e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2eb97078edc5c5595b345847041c52d997db1370cd1d33bf83bc48a296105fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfa10e2020b2e510a5668b3223e94eddd625ea0d4dba3ae04d97863b546e5cef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e74ef81c52e1544fb7bbf486839cd17ded15bb1e414ea48afb62db597b71f9e0"
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
    system "swift", "build", *args, "-c", "release"
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
