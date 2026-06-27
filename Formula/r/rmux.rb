class Rmux < Formula
  desc "Terminal multiplexer with a tmux-style CLI and daemon runtime"
  homepage "https://rmux.io"
  url "https://static.crates.io/crates/rmux/rmux-0.7.1.crate"
  sha256 "84cd80513f308ee3f6fc47f81b6239797c32750d016e9321e43222d7c2c1754d"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7364993686eca27f308fc561e017b0701502a93993d8b265140d0fd1eb065258"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ac85a6659ce5c5a39c01a329368efc45c1cd920db7b2e56d1cba3102df9252e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8203379256b5d0ca2ee9f79a43e2ac2773d8a7f55e8299ed72146eeea9d59de5"
    sha256 cellar: :any_skip_relocation, sonoma:        "c91f397556e784a93644f1c8cec5796105252714581379cbe54b5a342d929eba"
    sha256 cellar: :any,                 arm64_linux:   "1360ef3ff4a6823865b4559561abfa9705d2961bb0d3d7187419640580779932"
    sha256 cellar: :any,                 x86_64_linux:  "1c1e117acb1e63630243cafe704945ce4a1d9430bfe82b31126f6af175a7ac8d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "docs/man/rmux.1"
  end

  test do
    require "json"

    assert_match "rmux #{version}", shell_output("#{bin}/rmux -V")
    diagnostics = JSON.parse(shell_output("#{bin}/rmux diagnose --json"))
    assert_equal version.to_s, diagnostics.fetch("version")
  end
end
