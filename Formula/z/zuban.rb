class Zuban < Formula
  desc "Python language server and type checker, written in Rust"
  homepage "https://zubanls.com/"
  # pull from git tag to get submodules
  url "https://github.com/zubanls/zuban.git",
    tag:      "v0.7.2",
    revision: "98605cfae4d1cd453ca0b8110d824488edafb6cb"
  license "AGPL-3.0-only"
  head "https://github.com/zubanls/zuban.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "346d655f339ab9222a9df78a0093801c1ae10d91a85b692e9a7295dc9882889e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5428911ed449b3f298f50ad9f0f41f4e364c496865648f5183a7e42d8410b44d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ccedac9e31e6cb9460427a579434ef2ff2785ebc5e74496c1192ac5ff3571fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb3186ad33d72d3ae87c5a6b1feb413fd924732d899e8d3f5d02046d89053f11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c6f771fc9f0e420018e228615b55b41bb62b7cdae8ae20a7d9e891594a31f74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fa1db6f1101b8350f6837c43602f68677959dde1d7ea204924b6299134cf142"
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
