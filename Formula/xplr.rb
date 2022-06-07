class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/v0.19.0.tar.gz"
  sha256 "3ffd1c6caf6d77b50744ba0c4166c149c8bb4bf66ad3012292bc54b4064d3779"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fce72347ae7ce788a19528dbf273fca08f3640e6346d97f5075f803e5fb7c8eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7cbeb5c6e0426879f3a9a8e0cb29c4bddbe07c5ce12480c99b504bffcb80f8b2"
    sha256 cellar: :any_skip_relocation, monterey:       "eb83c45e01a9acf43f1d828b9c5759e57bb582dd44c3d29077e57ae7e571860e"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ec024983b2061891472ebf67427b315095b17bc02fc263b3fc722f0bba8d56e"
    sha256 cellar: :any_skip_relocation, catalina:       "6f1d12c9d764fd9bfd90e0f641ea86b478390d44a5253989621c5b7da373b08c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43387b5167054d1d7ce6a76bbd267a274279172ab7c5ab97506d534c13bc06ea"
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
