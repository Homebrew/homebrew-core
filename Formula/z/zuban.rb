class Zuban < Formula
  desc "Python language server and type checker, written in Rust"
  homepage "https://zubanls.com/"
  # pull from git tag to get submodules
  url "https://github.com/zubanls/zuban.git",
    tag:      "v0.4.2",
    revision: "18cc42318a37dd545adc456a3b515abbb2fbc45c"
  license "AGPL-3.0-only"
  head "https://github.com/zubanls/zuban.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c174db46af92e964b8167a3405cea2f9986199d4119fd07eaec3e144958c9b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92bfb1ec099df3e90b856f4c2798a8f63f969a0e7c72729979e5958979cf4643"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f311b0d7cce06ae439ae9492724749cbef7e36c5142da83077f81ee0a190947b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a1d127e9aabbf70b48643013c646a14967cd745554e63a2962b1cf412d226ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb5fc63db66b5d0f367c28dfa85b2a2eca3de55db550f4aaea3f8c76f0dd4d38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ad383ee7c122536c6f12bc9e9644accb957cfeeafe43d5d0c33e6ca3e392f53"
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
