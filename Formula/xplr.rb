class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/v0.19.4.tar.gz"
  sha256 "ecc4a3c10396963411357d0e8692cf8e96aa0c2364104a6c8569e19778b90289"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c4aa122202f808d3175192cce69fdfee7bfeebd647198d4bc030f63a4de168d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "660a5c80376d1d1541e1df81c59e090200b524ddd17eb82f4b8231c8a3646e66"
    sha256 cellar: :any_skip_relocation, monterey:       "8a2bc9b3a118051506c83b78311422ea597e13cf52f48a348c625eaee7c21ddf"
    sha256 cellar: :any_skip_relocation, big_sur:        "940a2e3277d7b7d88965ee068e89a1507ef2d953e5f4de5e358239c8c7e16a91"
    sha256 cellar: :any_skip_relocation, catalina:       "2a7798e14f97a8a8dfecedce507cb1b9f15f731764694635770425815e95561c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eaf506779a2629f3a4eb5306723e7b4088091253bf3b7d5489d8cb47c0754964"
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
