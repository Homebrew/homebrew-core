class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/v0.17.1.tar.gz"
  sha256 "94040d4b45f41b81ed71ff1e124e3db2f9e4e8f3e11c3ec76315df5bab68351f"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "616452a1276a745a3d064b48ce078b37cc87eb75afa3c75cf49aa1242b49155d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35994b34ea4d02f946d206ee00633b3404097c76976e1e244d5a0f65bf9ac8c2"
    sha256 cellar: :any_skip_relocation, monterey:       "b1a68090c7b630ac089d8ecf626f08044561c598831f6712dff9036e58fcab58"
    sha256 cellar: :any_skip_relocation, big_sur:        "eff4a8222435fc55d916b8ee609fd9d9ed7b3d2cc3f3f0e3d6b46472f1326f3f"
    sha256 cellar: :any_skip_relocation, catalina:       "739451165dd121fb5b4bbe22cf1b4457e4a907536961f9929ba32ec4d58f234f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d36186bbb0d792d8fed4b885096f491f61ce622c3ff498725d134a7a7be18a1"
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
