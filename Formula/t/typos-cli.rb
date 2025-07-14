class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.34.0.tar.gz"
  sha256 "41695125234174fdae345ccb6b4721dc371eaded1e10c68c43b41eeaba3fa6c1"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d61a55948e9ff5709081bec50e494d03dc9d009b9dffba90c9bcd242adca3cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70fa473134266a8d0e9c91c6ee8bdf5ea0c4faa89a9b9c2a5e9447be46d0686d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6c5ebcc44b878324c856b0331ec4ca8a509ca10f3e22cf3b3f3f664010804c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4367fca7a93b07071d0b768dbe7a27e65be9b4b28bec043864f9f8ca99bb87e"
    sha256 cellar: :any_skip_relocation, ventura:       "42a6ccebd2b60ec878e272cd329d0fdc9417c2130a8ddea2bd1839eb197ee835"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb8b35ef8c5f9bc2a096549d1678b66e68e0b50da45ac92cab22b9a93cfe6ba0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12dd363642495fbb71f136b7d0444fd6ddc2323fc59e859dbd342de276d603a7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end
