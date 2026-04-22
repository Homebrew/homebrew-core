class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.45.1.tar.gz"
  sha256 "0def3b2c9398257bc26818b008eabf4ab1aaf49fb3383abb25c46fc0aeb1ee10"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aba56c862db6473f2806ac6eb9aa5d2268735e43c02f3f8b9b73912f05622d1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebd26c977936129273ab0aa2d708885031fef6121296c20e34545cfdb8107236"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b07ecd6c3e8ac53cae0d888aeebcd0d330d40cccf2245ddc1200719e531abe9"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd3d5942737cdcf474eb611e0874dce7bc0ab8c31a06ffe8c8689a8be710e0de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba29aced9f26580178fe7ebb5adeaa76f891a2ac81edaf7dc8c7f27d666a250f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75acda61ffc1cb1a6cc50cec5998efcd2b505d3c6bf53fc870f925b5cf505dff"
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
