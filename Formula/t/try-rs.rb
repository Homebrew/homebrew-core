class TryRs < Formula
  desc "Temporary workspace manager for fast experimentation in the terminal"
  homepage "https://github.com/tassiovirginio/try-rs"
  url "https://github.com/tassiovirginio/try-rs/archive/refs/tags/v0.1.59.tar.gz"
  sha256 "7de87bc72f92f47fd8c314d06de741109383dc66892c15073c3a629333beb214"
  license "MIT"
  head "https://github.com/tassiovirginio/try-rs.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "try-rs #{version}", shell_output("#{bin}/try-rs --version 2>&1")
  end
end
