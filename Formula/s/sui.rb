class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.29.1.tar.gz"
  sha256 "ac16538e3cc4f84797d9ff48c2dd275362a909295fd2e76cc5ceaaf123d551fd"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a493c3f338fde2803771c9d9cb82d236b2cd1580027c17eceab193c1ba2a1f71"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a255397434bdfdb0e23a3ecf19fa098ffe35dd09018f909f4717546374e451f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca2bfef57354dece622db0b850209808b2cf498ade3ed79f77a3705dd6f944f7"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e23bb052018d8f35cb9065158824f601fbc2e1a6f57c67f95265f4f6b848561"
    sha256 cellar: :any_skip_relocation, ventura:        "44bdd034c84f8efb16a30b37f121e492b380fa4da1ae3017010ae754f66de1e4"
    sha256 cellar: :any_skip_relocation, monterey:       "bf047806f5e01dfc7f29c2ff4e88ac3a2fcf477e2042dd5415b582c0e6447b9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6815d9a6a76a1fef32931304aa5108b4f6745a6513c3f9cf8480a7a76d664916"
  end

  depends_on "cmake" => :build
  depends_on "libpq" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
  end

  def install
    ENV["GIT_REVISION"] = "homebrew"
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
