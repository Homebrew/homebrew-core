class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/0.15.22.tar.gz"
  sha256 "319db883d92d2aa140c244bd8fb2fc690f25b5a8fd37210b52e069ca0c1513ba"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e42fbeb75fdd8524f6eac1d73ee214ff592dd34722a57937e1c290de0ccab9d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f24764963c385c6c758a97311e6e6bc54e55aee724fdeb78d8ce687c94ee6fd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db30ada7f97fd6d934961f0e2c646ae647c0c15ed08fc2ded8e5a11aa2266a25"
    sha256 cellar: :any_skip_relocation, sonoma:        "248dcf905d283b2b9207089e71d962303cde8ba1f2b911855975d9e9339be8a0"
    sha256 cellar: :any,                 arm64_linux:   "62bf8b68eba9b1d9614d089ce96035143f81a6598de83bcf320f812470211fee"
    sha256 cellar: :any,                 x86_64_linux:  "4cd3f624e5a7e24a55ad3316580e791ebe6930c43cee0545682512e89af98653"
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
