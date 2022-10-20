class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/v0.19.4.tar.gz"
  sha256 "ecc4a3c10396963411357d0e8692cf8e96aa0c2364104a6c8569e19778b90289"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c9e8c06d86346c2f768d24f3999179102efb08a268181d2ad0d4c76b4311a6c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0892d8c2e5c2c787c215c7206c2a2026ad012b3aa8318f6a9b2f992ed45faa6e"
    sha256 cellar: :any_skip_relocation, monterey:       "59d20ba7078d534b5a866422c98ca9ebfd54a6c2c34b9efd32d211a9f9894b4a"
    sha256 cellar: :any_skip_relocation, big_sur:        "8656c29924e1340e978f85d9e404cff8ee91ebaa18d65ac75aaf94806f6e6b2f"
    sha256 cellar: :any_skip_relocation, catalina:       "b5d102a7b8e4f90d511973fce913818734eafc5080a2e44879f112df19cd0ab4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "333990c435846daa0d05e4068f9c184561687157a7870454f3c1a6bb362a68b9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    input, = Open3.popen2 "SHELL=/bin/sh script -q output.txt"
    input.puts "stty rows 80 cols 130"
    input.puts bin/"xplr"
    input.putc "q"
    input.puts "exit"

    sleep 5
    File.open(testpath/"output.txt", "r:ISO-8859-7") do |f|
      contents = f.read
      assert_match testpath.to_s, contents
    end
  end
end
