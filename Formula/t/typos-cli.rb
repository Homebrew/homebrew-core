class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.31.1.tar.gz"
  sha256 "58bb9286e877e77213c941d5f0f8c999606e27a333edb2258e5ee7e5a58b4cf8"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d8cad5fc8cb37438a4b3be42f5a2070d46a1a3965c97426b2e53801a39f4269"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8c7b1376d4b703bad96c1ce74fd85d2b016da51c71444a38c19bb817d314005"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "259d8912f98949252cb9e08c09e1581e44324638a24f0bddf6650dbbfb546def"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4a842b26eb8f946acd675a79c6d8da9e480c52113dd61a9e57de536228dcdaf"
    sha256 cellar: :any_skip_relocation, ventura:       "7fb132a6ca19d3a051e40271ec6fbfc0438c019922624176cdf09eb5ac9a092a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03bfc4a9882b0552e3c10219eaebe3a6237cdc6411d949ffc028b7706f9af7c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57f7f8330388457d78b6ba46bf846378c99df4b17694ac675541f9887ee6bf16"
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
