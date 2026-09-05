class Sabiql < Formula
  desc "Fast, safe-by-design, driverless, Vim-first DB TUI with ER diagrams"
  homepage "https://github.com/riii111/sabiql"
  url "https://github.com/riii111/sabiql/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "745738d629b618f7f02190c176a89cebec29bfd3dd3877ebc12cda5223e8672d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f81bd1a25632e8a702561833d39d0cb9d5fb54d293840be5bf9e7fca02ce1a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7644b246b0652401c9932b924d0082afab598f5f7f8fcd476701f934635b4f4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c63aed69ad9accb5bc652db7d203ed23e0b9559f1776e2256a3267f67a94cb7"
    sha256 cellar: :any,                 arm64_linux:   "85b2bf5700ad27f351587ea4903e7f3e3a609388077cf8fdaab2a35a38647659"
    sha256 cellar: :any,                 x86_64_linux:  "82137759c7da8f9a7849efac2b19d76f1856682de159c9b0bad9230d28ae770e"
  end

  depends_on "rust" => :build
  depends_on "graphviz"

  uses_from_macos "sqlite"

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args
  end

  def caveats
    <<~EOS
      PostgreSQL and MySQL support require psql or mysql in PATH.
    EOS
  end

  test do
    # sabiql is a TUI application, so only its non-interactive CLI behavior is tested.
    assert_match version.to_s, shell_output("#{bin}/sabiql --version")
    output = shell_output("#{bin}/sabiql update 2>&1", 1)
    assert_match "brew upgrade sabiql", output
  end
end
