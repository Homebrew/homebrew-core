class Rainfrog < Formula
  desc "Database management TUI for PostgreSQL/MySQL/SQLite"
  homepage "https://github.com/achristmascarl/rainfrog"
  url "https://github.com/achristmascarl/rainfrog/archive/refs/tags/v0.3.19.tar.gz"
  sha256 "9b26d6f8515f7b382c07fecd241b13bdcb15d9945e7b858edcb109e202e641de"
  license "MIT"
  head "https://github.com/achristmascarl/rainfrog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "134debcce965ef028eaac1a37a25e3bf8cfbdb5255d2b6e070529a4564880b77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "feb3eb70159a3fe03818924cf0f39b7dee5c1fca0d4a7b5550c07d607d75a564"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8729dded811a3dadc9e75a2b107e668cbe1324ef18e6462568d283c40e11c311"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f188d7cead7f076251778e9cade88c450649044dd9258eb14635793ef616b02"
    sha256 cellar: :any,                 arm64_linux:   "577dad878a360263b5ff30ddf4da47a14231e92fa4624dc9f296421464580b4a"
    sha256 cellar: :any,                 x86_64_linux:  "26fd64590d89c3bc1a1fb8945b7354bcf1ebde3e2e04e23de9faaffe0528086e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # rainfrog is a TUI application
    assert_match version.to_s, shell_output("#{bin}/rainfrog --version")
  end
end
