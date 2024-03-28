class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "2354027cf56ab289bf3d498ea2f80707ef28b47765a50ea951270c325875a58e"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cdd91f776a1869016a6367a290b7c157f5dbce8e81ffbbdabec4a16ed5c9a56e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2314ad69e8f21db60fac5d49ad3e14e9c86d759c5fec3914a88a90945efba346"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8aa13b1f827339e0e3269a99704e184c2010191d1ed870e554938111cf681c8c"
    sha256 cellar: :any_skip_relocation, sonoma:         "c818ed19c3d5f3b1742212ec790c8691a8309863376549f73a17214f40993732"
    sha256 cellar: :any_skip_relocation, ventura:        "562b7a70f55cf4fbe5eb8aa1ca8bced661a5cbc45e69a6fcd1ee575b44402b55"
    sha256 cellar: :any_skip_relocation, monterey:       "dbdafa627463323aaf3402805f6809f8e2ce24b7026d427c150f311f46b5bee6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddcb9b5477ccaeb50908c40ec02067e9cdd963bc5cccdac70b941b36dc44ba0d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/ruff")
    generate_completions_from_executable(bin/"ruff", "generate-shell-completion")
  end

  test do
    (testpath/"test.py").write <<~EOS
      import os
    EOS

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff --quiet #{testpath}/test.py", 1)
  end
end
