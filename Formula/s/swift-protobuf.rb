class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/refs/tags/1.28.2.tar.gz"
  sha256 "d086deab3ca0b74751fcc1905d268697b0d471e747fb50eced94941f28b35fb8"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apple/swift-protobuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd56104efbff42d8793ec02ed212fe8eedd011a045e9063dd9f11fb602a8580a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d205878109743b4bc66bbdab6ecb6e4271a99a5a2fd929faf6648524107f3cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b51e076ed77a2e55bb899f75e4626ff9ff89794362b7fc14d84304c4cf3a9dd5"
    sha256 cellar: :any_skip_relocation, sonoma:        "67eedb80e3f078c92b6770a09a198bde2cae63dc60b8138b561481b579114433"
    sha256 cellar: :any_skip_relocation, ventura:       "8d2430ecad2190aa1106d3b917c2bec66a6e4380c3fd741f23515bd24c15ebef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0290054e89192d859c7bdca84ebf40cb8cd90c0cf3cda9b4bc43ccfd6c6f7961"
  end

  depends_on xcode: ["14.3", :build]
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
    assert_predicate testpath/"test.pb.swift", :exist?
  end
end
