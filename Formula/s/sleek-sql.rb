class SleekSql < Formula
  desc "Sleek is a CLI tool for formatting SQL"
  homepage "https://github.com/nrempel/sleek"
  url "https://github.com/nrempel/sleek/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "503e9535ebd7640a4c98c7fd1df2eb98eebed27f9862b4b46e38adbd4a9cf08f"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sleek --version")

    (testpath/"test.sql").write "SELECT * from foo WHERE bar = 'quux';"
    system bin/"sleek", testpath/"test.sql"
  end
end
