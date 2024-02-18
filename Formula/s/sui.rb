class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.18.1.tar.gz"
  sha256 "120021899fd7656ff8b69a998e5d6be822fc780487ec78f4fac6779838fdfe80"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b5baaceaa04c90b5a1ed39fe449d295a05d5cbf715c54a6ce1ddb94bf8dab416"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a1baa6e480aed4bda350396ebb15afc61d82ac58b76efc3d451c2d952baba91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f41d264980b7694a5e82249003c384344d6467a1bd85830cecf4984a121144b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "d3a88468a4bfeea9f9536b2d4e114eda6b9ebe2d24f87e1a8238323a9876d82c"
    sha256 cellar: :any_skip_relocation, ventura:        "859b97a1919a1fe08befd08b2ffcea4dff9ee2f785ef0cba4f8e0ebeccfa985d"
    sha256 cellar: :any_skip_relocation, monterey:       "a721fc9b1c2061a54b15768bc36a900237209a9411411449f91af6f5840b87ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58fc30c82361f9a7a8d330b6a1ca8f3f97487d9a1f2509a478069be8c4fdd9e9"
  end

  depends_on "cmake" => :build
  depends_on "libpq" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/sui")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sui --version")

    (testpath/"testing.keystore").write <<~EOS
      [
        "AOLe60VN7M+X7H3ZVEdfNt8Zzsj1mDJ7FlAhPFWSen41"
      ]
    EOS
    keystore_output = shell_output("#{bin}/sui keytool --keystore-path testing.keystore list")
    assert_match "0xd52f9cae5db1f8ab2cb0ac437cbcdda47900e92ee0a0c06906ffc84e26f999ce", keystore_output
  end
end
