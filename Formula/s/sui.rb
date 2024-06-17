class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.27.2.tar.gz"
  sha256 "b665f10f9612b5cb8dc11723055823d1569628d34e266806a2c192b10fcbc75f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "269a900439a07afb7bcdfa4c68748bf29f4775624b3866c300fe90da33533615"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ba8805ecbaf4d3c761b2dcf7e416a2a136917b1c3674ab57e4103b8629e3ee4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f5fc0dfc824a97d4c4e827fb82a326cdf00f4e176fa24c9c92bdd3b8488006c"
    sha256 cellar: :any_skip_relocation, sonoma:         "8c63e86925d0355f643d7a905fbb15e20f4b9414207bf6c8d947cc4b663a333e"
    sha256 cellar: :any_skip_relocation, ventura:        "d5e8c5fafd2ac2875fa9b1cbe087c010a145cc385e636e742390747a4dbd1e2d"
    sha256 cellar: :any_skip_relocation, monterey:       "1d5b5be0b770b6355e5aca1f8f4875d3c43ba80e504459d5d49e42876d50ae95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be29d71368fe63550d581ca887a1f0f18e66206b384f4dba6a821f09b24ad600"
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
