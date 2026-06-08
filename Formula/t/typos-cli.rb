class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.47.2.tar.gz"
  sha256 "baf2404aec76101fbe265e058cbe8765dd1dfc802c55c3f5678f075a5b23d998"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b68f935502f2f9550f6c13c02d3eadc70c67d27c3f06336cbbf4e65bd074a07b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ac720000f91c4d34072aaa83c13da4c2d847942a5faaeaa99873cecd419124b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d5e3c7193ec6a927f3c241c5e0fe7e0793dd1c785cc995989591b701e53c59d"
    sha256 cellar: :any_skip_relocation, sonoma:        "813dba48cb62acd933cb1748b209635f86a2124c00574bf6095a20e48ca76ced"
    sha256 cellar: :any,                 arm64_linux:   "205297a4b4e0dfd3dace1d881a7d20f21463f86c2746630504c6f46615abc568"
    sha256 cellar: :any,                 x86_64_linux:  "1597d4c93029b3d04b3e0bb406d5c810663c63251860f929c3915064a44bb79c"
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
