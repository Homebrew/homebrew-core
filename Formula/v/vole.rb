class Vole < Formula
  desc "macOS cleanup CLI (Rust rewrite of Mole workflows)"
  homepage "https://github.com/wukongnotnull/vole"
  url "https://github.com/wukongnotnull/vole/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "23d2f02db2320d44195ac519008bcd93def368439eb4403170b7c913673b9172"
  license "GPL-3.0-only"
  head "https://github.com/wukongnotnull/vole.git", branch: "main"

  depends_on "rust" => :build
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/vole-cli")
    pkgshare.install "data/rules"
  end

  test do
    assert_predicate pkgshare/"rules", :directory?
    # Exercise real functionality: load packaged rules and emit a clean plan JSON.
    output = shell_output("#{bin}/vole clean --plan")
    assert_match "\"schema_version\":1", output
  end
end
