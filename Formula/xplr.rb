class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/v0.19.3.tar.gz"
  sha256 "7dec7a428d45fb233ef3b9d0613aeede9322cc15650144ab3756cf0b30d1e6a0"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5034fddd6a493420ab3c55f1f8a811ee2e167aec44fa85bef5d0b527e7fac08"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9cb127e73462d12456f170407c7a3ae6e92fdc6c8b659a5e2f0b596f81bf8296"
    sha256 cellar: :any_skip_relocation, monterey:       "d1861da7e107375bdc9e00d1d85200128b72d85041dec5c63c239dd4be8a5879"
    sha256 cellar: :any_skip_relocation, big_sur:        "12127333064897e6b2fd974097f497ca169f9febda85ba7b1634406da7a879c9"
    sha256 cellar: :any_skip_relocation, catalina:       "5119460ea6acb66bbe13e96bbc648cf9b69c97c1d9dabb58f44b5aff3071a214"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69c54caef9c9c2863e2b59f9ffbc53c4b2f578ad48c955bef56aceb3f59956c7"
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
