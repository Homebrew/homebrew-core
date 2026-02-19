class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.43.5.tar.gz"
  sha256 "2bc8695297af45c075717d71b60e4e41c04901565b22415c68871ced4f9418aa"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f9879f96580ccfef6199b7e8b9f63cc5274d3bb38f089706c029553b0661daa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a87775ca10397a20177f7bf6c6f7224383571ad30a8653d934d1c7c13a09caa4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "547a4a8e3cfed581ddd8b1055217d14e2167aebcb175a63640d8e33566e246dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "42c53ec9e2057494c24e5661076e6bd605546f3ecd11c9bb0b26095823321299"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91b006878bae307d3ed704c3ce5959bdd39515d7293b314276df29a55ecb6867"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64316cd207db2ae1fe36269d157c7d2cb78a8dc2ac3e5a6aa38497011dea168f"
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
