class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.64.0.tar.gz"
  sha256 "4abf3811377a777b253c1ac989169a998da4391d072590917d47d737caed2abe"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3b413289a2866e4244cdf24f7d2476312f90ba6db9733c8586a0b30098ad673"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ae3fc904f7bd5c7215b07f2b92e95ef32382fa98a5795cc8a0bd9e532bf5f7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d21a19e6c41bfbed9c389bd416123eaa3d381d7c2390930c91af0886df81d59"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae21fdb991e6a3d50ffcf316c97cbb2fdf17badb3d48a494ae15715895b4fc0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2a878a2f55774fc43e4cbaf965e9eb59ae7a02283cc18338aad49c12b0f48f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "778cabca36f90613f66980ddf40432430c61d5835a471ef103e2838416613b8b"
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
