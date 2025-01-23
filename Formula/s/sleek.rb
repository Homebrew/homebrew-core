class Sleek < Formula
  desc "CLI tool for formatting SQL"
  homepage "https://github.com/nrempel/sleek"
  url "https://github.com/nrempel/sleek/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "503e9535ebd7640a4c98c7fd1df2eb98eebed27f9862b4b46e38adbd4a9cf08f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91a9ef96d0eb6c5a90745fc5d0bd73b426be96d18b4293c48fccd3a9de933bc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c8a08f1994cd26924faec694399aeeeb94b8b82a1b8f5b7e67773c763d4b618"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5cfcc553c15db6aa1eee7fb3c1c9f57d36728f2325aa3f679910ed79f8ca6396"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fbd67bbb52e8072bffe8b656161e894f35156daafa3a53496aae7e8b3e50deb"
    sha256 cellar: :any_skip_relocation, ventura:       "0c26c3a372199175fe36833996cac1f619b5415442414cf3652af72eeb01f3c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3f2f948129d7eb704889e0ca9f8132b2632e525ca1f239089c4aeb22f3810d3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sleek --version")

    (testpath/"test.sql").write <<~SQL
      SELECT * from foo WHERE bar = 'quux';
    SQL
    system bin/"sleek", testpath/"test.sql"
  end
end
