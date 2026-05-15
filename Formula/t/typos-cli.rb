class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.46.1.tar.gz"
  sha256 "d700ea13be53eee4633be29b9918b3654aae6359cef630757b8dbe24d217265b"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8204fe535717deb14dea95b708ec4785201e61aeed74f2245a54b297a96d5c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b603555a21d14c03b7ef84e776d46401772b7eb7ca56590207afe2fc152ed95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2eb949cd431774cd5478fbd65311160325f1a42764e17aaba5481db6c10d5a9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "883dfa4193f94952a4e9abd284022c6ef2efdfbc26196d2fed089c878ab873c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f662bae3f481e8119328adbb9e085f318cac91cf6ecd6cbfb7a8328981c179bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "799be9a82cd0002d182de94fe32ce60cdbcf73b421cbe3a8f6af7b0c62da07e9"
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
