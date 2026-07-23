class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.48.0.tar.gz"
  sha256 "11b662d163b258244f7f27ea1d0f39a17d1032fdc983d527f290dcad8253d355"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1a0a1b20c2103dad57769c356b0c277adcb3e0df5cfc4ff619e70365a4a9231"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ca94543749b5c40d655e9e71aa7cda0d70b55bf013ce823bc088052e0f79257"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05a7fb4875b4fd7aa979516de5b39a94c9a8352bb4253ebdcf0c5282f6cf00bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a3ad6cfcff49e9872a3324dff072ea427b6deafff13b4bf1c00be19c37c694c"
    sha256 cellar: :any,                 arm64_linux:   "db1cd533361fa1f6455f08ccc82323c39c759a41414539d1c7919010590b11dc"
    sha256 cellar: :any,                 x86_64_linux:  "ae6b0eee0801104875ab4bafec166456b4345c7bd30a6b8ae1fa5a13fc04dbcb"
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
