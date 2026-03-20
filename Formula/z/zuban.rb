class Zuban < Formula
  desc "Python language server and type checker, written in Rust"
  homepage "https://zubanls.com/"
  # pull from git tag to get submodules
  url "https://github.com/zubanls/zuban.git",
    tag:      "v0.6.2",
    revision: "8d0e851312a7507dfd917bc5473dfced5d52e5c1"
  license "AGPL-3.0-only"
  head "https://github.com/zubanls/zuban.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20b205da6b19499c1a760ef659ef17b8ef690aa07e985ba9e4b9c1254c8b937b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b8c568c07b5d2e4ded3b7b0ed48cbce873825a9dab40d8a3f996d8d251c4702"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6dafb8467b5587bf0c114f272ae4eb066854f324a46af967c6649ce4cb75b8c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "84489dc3199eb45dc7f5afa266ee3bc64738a7238cde699ebf6e055d4216e55a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c925122b2d39318e12c9ac19e10fae2251169f238ba012750ac1215a423d17e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec4d21fe0bc81057c770482b62c031eb6028aea127d0bd539005dcdd3ded4cd4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/zuban")
    libexec.install (buildpath/"third_party/typeshed").children
    bin.env_script_all_files libexec/"bin", ZUBAN_TYPESHED: libexec
  end

  test do
    %w[zmypy zuban zubanls].each do |cmd|
      assert_match version.to_s, shell_output("#{bin}/#{cmd} --version")
    end

    (testpath/"t.py").write <<~PY
      def f(x: int) -> int:
        return "nope"
    PY
    out = shell_output("#{bin}/zuban check #{testpath}/t.py 2>&1", 1)
    assert_match "Incompatible return value type", out
  end
end
