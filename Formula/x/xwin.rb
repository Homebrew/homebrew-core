class Xwin < Formula
  desc "Microsoft CRT and Windows SDK headers and libraries loader"
  homepage "https://github.com/Jake-Shadle/xwin"
  url "https://github.com/Jake-Shadle/xwin/archive/refs/tags/0.9.0.tar.gz"
  sha256 "6878480d7a4126fb4390fe083ac0509bf43e4d284797e2ddd0a4a01fd614f35b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "985ce687c46b51744fcee0e62c1dc9099a36be3f533596addc8e62b908714a2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dab5dab1635297f505374617e69f02b05df6ffd26797ea8c0cb6febb66d71fab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7d5721f59a623ef4d90a73872d001f10809e8be36fbb79285aeef5bd5303b4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3a803aa1c5d0a44ecd035d621655c0b6e2fffb77ffe00e839caab3dcdb28f0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82b561aefd09e770b88fa4310b7b8e5ce469241fd53e34e91c7a77ebb2c2cb92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40f5ed6b41c2e68fd10bfb4cb0293b1866e2f045fdc34f6b1e958af7f34a18ce"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"xwin", "--accept-license", "splat", "--disable-symlinks"
    assert_path_exists testpath/".xwin-cache/splat"
  end
end
