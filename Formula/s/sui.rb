class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.41.0.tar.gz"
  sha256 "ad3ac3b956f0f54da51afcea192a53f65ea56808a2adc7ba3cf913abe215c914"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6805405c969c54b5d3b1fb53c144b5999b5ec7ceaac661062ed759b20785a9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc0ebd5b6bec91c58f3c8f7bbb2d8237b8fc9fdbb06fe546853893676fb59a3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "301e3d7efa26c50fbb588a770d1f021431b9c9115a89821429c9927666b7436a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c21c6d46d77cebe2ed33a09e9e6e37a0884d6f4ac29717efcab1f4b5e8bc7090"
    sha256 cellar: :any_skip_relocation, ventura:       "2ee4365dcf41fc4c0c0918678555922a170850ddd03c79c05c86f7e6417edbc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "970e3abfbd1d64f04c2649cd9880c36d8a3dfbe88dc898bc28ca1afbbaf222ee"
  end

  depends_on "cmake" => :build
  depends_on "libpq" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
  end

  def install
    ENV["GIT_REVISION"] = "homebrew"
    system "cargo", "install", "--features", "tracing", *std_cargo_args(path: "crates/sui")
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
