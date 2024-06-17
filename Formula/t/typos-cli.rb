class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.22.7.tar.gz"
  sha256 "b7f8157e309efc17a7ec44de28d2ad7f42a752f37a022685b2d92e873cd5a39f"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f808cbb1319eb2586cc78935b17ac41c6f37d2ccae4081c1552ca24f96a7b6a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4d60d7d426e1f1ef74b52ba10002cb06ec83197039d0b0effe1ca449e05b285"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "420e2b4db2f9ca1608f9091436e15affd03780c176ab9822eb52148d44b8d004"
    sha256 cellar: :any_skip_relocation, sonoma:         "0dae424f276317dc535d8595440b0b134e831a2798364cae7512579327a92c13"
    sha256 cellar: :any_skip_relocation, ventura:        "ee3bbdd48337ce25ae2ac6304193d764a2eeab741d43ef997000eb34d85e2df5"
    sha256 cellar: :any_skip_relocation, monterey:       "8ad1a9963c2161e91e5723449b59684c915031d10404269b5e7b324f01cd4439"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd52d0859dbeb7bf4564ba4c9315de4a96f79918c5788f717d651e66aed7347c"
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
