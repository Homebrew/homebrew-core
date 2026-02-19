class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.65.2.tar.gz"
  sha256 "05f9b2c5c725266fc3d89724a8ef3d29d74871d00479fc5b0c55a8e94bc8e72a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c305b5ae9901fdc19e8813956202c2530fac7e842188bc856dbdd66ff1bd14e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76bae5623b17bb9a4915cc617945c207aa247ab56f4edd0a371f32fc06f3ca58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb28120beabcc8dfdd631364960c4acdfeae0c6fb44209d12f9e0841d19f016e"
    sha256 cellar: :any_skip_relocation, sonoma:        "bab2c0956e78a8234d48dc7989e5310691adc13fb31d0d18b6cb8e37861b0059"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "398483db85b45fe5ffbf9d5cb3d1022565789f92121deb26912d09fa472bfe98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2631d41d4f84e1a0919334da666ac7997d40688fdd6c33cfe67d85fe5a68e71"
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
