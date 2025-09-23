class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.56.2.tar.gz"
  sha256 "3e61ec6a53879660927c30e5e2dbdfff0fb607ab8adf19de7f174053ca9c0cb0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "565720ebff1bdab685f8443705e562761867ec1371edcb508c4ecf63d0e9dec4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d7ffbb43326677b66a5a784a40c3d025d1a4b481ecabf3a3c48962bf66a72ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "290bc21928a2d893e3ff5f2df749c0d72c72afb721a0f8a2d7431e37513529c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4c907087c823e28eec7eaeae440eb9377ddceab9211761da7c3249de31d5695"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f336d165d5c0d550700fc1eac5dc6a02d3ac855ebf074f428ba112d743b4c8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "929e65d801f7f11d14a12c2e33740db47ee4c83530172281bae7e15937c92afb"
  end

  depends_on "cmake" => :build
  depends_on "libpq" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
  end

  # patch blst to fix x86 macos build, upstream pr ref, https://github.com/MystenLabs/sui/pull/20921
  patch do
    url "https://github.com/MystenLabs/sui/commit/85fe7ddbe01067637d2e771360d26675dd5fd2aa.patch?full_index=1"
    sha256 "ea19ec19ff5cb969f218363618a23afa1d3b36e8ddb04670a5fcbaa886321559"
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
