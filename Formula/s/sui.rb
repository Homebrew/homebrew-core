class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.48.0.tar.gz"
  sha256 "a50f3453e177e30bc045c7491c005690f4682e839f0bd0260c0d394a428fda99"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7224c57f45246d1760aba26157ff07053fdf8d2d107bf278150eabd0bc97feda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8eef83225c071f0ba266a3e0175d10e104516b099e1aeeefa0c97d9bb5f80d37"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b4619bcc780ed6f6cb359159a001cdd00687edbebe2ae9b04a717f6e142e8df"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5b3b56d2e16e6856b7384b6a4120a710118ab8455c3cb66acdfd13c71b154a7"
    sha256 cellar: :any_skip_relocation, ventura:       "687aa906070da044054e4ce372b648c4902f2ed9fe39fcac9d3ff19a772f8d23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c3a6579e62e29fbba7830fcb447bf30038aafbc76dd09faa06ac0add3571a44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f393d8bb6995d187fc39352305868028c2dc32fa48c5e14d00c5de54c21ffe70"
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
