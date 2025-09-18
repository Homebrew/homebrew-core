class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/0.13.0.tar.gz"
  sha256 "1be5402b5ca6925725fcb73af70a07b515246009d7bbb14f17e7f5adacd8a307"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b31c08a17aac31b9620e83623274eca614857b289dae5023dc16078eacaf180"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1c3c9aa44cfcb41d5e44dc0e9debc9df7418c9331f97ee9d3a90137eb433039"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d02255c55f2efcd59764cda9f49cb213e49c3a631c18e72b4e073f2578a97c11"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d4d0136200caeafd9a5dd2b5480f969cacd5373f20163795cdf36da4b3d379e"
    sha256 cellar: :any_skip_relocation, sonoma:        "adcc147674022bb91682d0243806cfa2d7b5701af5979a52cc0660408ed0694d"
    sha256 cellar: :any_skip_relocation, ventura:       "711669146f8ae198ec19f8303533cca49049051c9edea8e7755cc75a170fea3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aab0211f923f12fb9dfc4a71ed3d52ed4174b24a4437fd96c0f5e27ddd5fc1a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b16d7cc556f0bd63e032efc40e4dbc73313255973a336f39f28e6349009c8a5a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/ruff")
    generate_completions_from_executable(bin/"ruff", "generate-shell-completion")
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      import os
    PYTHON

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff check #{testpath}/test.py", 1)
  end
end
