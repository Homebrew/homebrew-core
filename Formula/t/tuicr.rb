class Tuicr < Formula
  desc "Review code diffs from your terminal"
  homepage "https://github.com/agavra/tuicr"
  url "https://github.com/agavra/tuicr/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "256ceb1c404e52994b3f9b647b4517c0b257a5ad8f0dccaccb01daa7d7117200"
  license "MIT"
  head "https://github.com/agavra/tuicr.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "tuicr #{version}", shell_output("#{bin}/tuicr --version")
  end
end
