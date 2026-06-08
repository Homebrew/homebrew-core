class Zuban < Formula
  desc "Python language server and type checker, written in Rust"
  homepage "https://zubanls.com/"
  # pull from git tag to get submodules
  url "https://github.com/zubanls/zuban.git",
      tag:      "v0.8.0",
      revision: "c04cbb6a41a46f1b47dd663b4a7e4a6256c04d97"
  license "AGPL-3.0-only"
  head "https://github.com/zubanls/zuban.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64a90895fa107653be9035b41bb01c942ffe2821ebe1a618d4fa82728c1aa2bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "216390c029171579af286de38bfd764f0442e58c689491f968239fdf9e3886f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f15ddd24c631ce07b0967998227410cc3fd449df5cc6a629217194191c1a864"
    sha256 cellar: :any_skip_relocation, sonoma:        "994e4f91928a0bfc74d9f39b5f5c1a584e66eba553efcdc620b5a4e305e5942d"
    sha256 cellar: :any,                 arm64_linux:   "b3869590c80e62e7fbf86ab98a6dd741258778cc1b557b35644a0d948b8cc9ba"
    sha256 cellar: :any,                 x86_64_linux:  "91c9d27a6bbf2a097a1e196ca9bd9c7602b446062880c4350110efddb1a478ef"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/zuban")
    libexec.install (buildpath/"third_party/typeshed").children
    bin.env_script_all_files libexec/"bin", ZUBAN_TYPESHED: libexec
  end

  test do
    %w[zmypy zuban].each do |cmd|
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
