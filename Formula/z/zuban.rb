class Zuban < Formula
  desc "Python language server and type checker, written in Rust"
  homepage "https://zubanls.com/"
  # pull from git tag to get submodules
  url "https://github.com/zubanls/zuban.git",
    tag:      "v0.6.0",
    revision: "0b4b70138acd285cc4fa4809510756e442dea38f"
  license "AGPL-3.0-only"
  head "https://github.com/zubanls/zuban.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6eedae2a979a7090c5feabf933c165cc416521f08a8704ae3f60826ceb41158b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a0794e0b5649294ce649ffc70dbb761e106580e68e72999b23635da0120e047"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8912dc4a46ce932dbf84336325796ae9f35346741bd568edd64853923cb8fe4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "79e3ba3ea2df89599bac617f9aef3b5714227123f5bfe8d2b4c7af84f1f70ff8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1eb0260e96904d8723db15e68ea40dfde685b5a5b6dba913020df8d4bbb6d52e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d555ffcae6be5fd0bf69b8ea71d6aa5f046e2c7d68f00a842d836ed87ea40982"
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
