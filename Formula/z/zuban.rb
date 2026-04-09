class Zuban < Formula
  desc "Python language server and type checker, written in Rust"
  homepage "https://zubanls.com/"
  # pull from git tag to get submodules
  url "https://github.com/zubanls/zuban.git",
    tag:      "v0.7.0",
    revision: "a0858192cd86b25de2e29b1ec399047225d1cef5"
  license "AGPL-3.0-only"
  head "https://github.com/zubanls/zuban.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f41521941e199ae8767a34205a1103203e6ed24db3169eb83e3ab660e9274890"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd2588cde0eaf628dd1837a26a495a51f2a1d0f37aeb81732967f01765dfebaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd66f431b6bb22eff08d4fc870a6540b01615d9c97530c83c2f9bb30a5e7116a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca779bb8afa85c9d54087572f85dda10305dd18e308f0c5a421a7e5f9124d6ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15963f51263dde72b6c57e82c650ffda725aded378335206679e0063e42dbeb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e17a78cd85c8a65781853b1619df43ab5d6f95b018d4e0743c6e2ffbb77dc46"
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
