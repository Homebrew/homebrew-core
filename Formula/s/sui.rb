class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.21.0.tar.gz"
  sha256 "4545d2e8f63d329e5a954539ab38ece1a93ba99127323122dc27940c98484494"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e7a8f7a8e62d0fb51302c214bacff3158a53138c35ecdbe341721d3f4e9dace"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aef0ff0c382f391e91c9753e414b246f4235de499a3131e88785d6eb045e2d00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eee2bfaf9c3ef8c593a6e512a6dca72db4fe786393de495faecdfc919e792279"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e130e46a8d58ab8c15f0537a63d73deac3a811841ec5bf42e9ae7ac1d7b82ac"
    sha256 cellar: :any_skip_relocation, ventura:        "5241104fb7a0febdb6ea3c3b4194ed8ffbda4ba499e6393e72ac02e96402d675"
    sha256 cellar: :any_skip_relocation, monterey:       "b3517e3cf663b70919a15dde1dad45ddf8e7fc4fc6a05deb3095bb0c5be85cbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b301c61435d2a5164b074b411eebf5cabaa9fdcc7899a973c66c96164d557be"
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
