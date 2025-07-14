class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.51.3.tar.gz"
  sha256 "da68ec6996bfbab6877544a632a206f72d1dfd83ebc5a99ef4688694142916a4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae0af55fb353c3a48b4c5748d8db7b788c0f59072503aea421f5b27131b6ed3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "805b2289b655516c5042d6ed250c26cc60c7189d00f978f1c6a58f6b5e91d626"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c3286caddc3f1f57ed0cf68dad1f2e6073a4ef9f35c8bbd2a27e5f2566c89d25"
    sha256 cellar: :any_skip_relocation, sonoma:        "636105c7c3e4b08bed3e411d4908d9d4e849cc38794d358af152e7cf2d011e04"
    sha256 cellar: :any_skip_relocation, ventura:       "55b59a4700a45de276e9a79d71ea7e050c8f8052c1cdb07ccc08bcd8f3ab0f0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fc6db4f67f269cfa99be6dbabe9e4d7551560fa8cf09a7d738bf2928fdb0ce2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b0ce869c461610d3f90194c3c62f905979c995b95ed5d5a86e131f92cb71974"
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
