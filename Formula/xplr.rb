class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/v0.21.0.tar.gz"
  sha256 "0daa8cd12f543d10fcff20779c72166d23090a149c9523043512eeaedbbab3fb"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f55718d1ec81b1ea951fa203543b64a625875c39debb9790006d2910e9c3f13e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f47fc0fb47a08317bf11ead2b468c6c7c92a7849a732bc22acfe201dd845ccb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11659f4f5d61839a3b802cd8e31dea0e2d07de4ea276dc369cf062d9bce67d0a"
    sha256 cellar: :any_skip_relocation, ventura:        "e3b532fa2a751de33fc54cc5a9eee9877ec23d3abf4ee7ef965061e57e21f3d3"
    sha256 cellar: :any_skip_relocation, monterey:       "cdef9c7a16ee4bda97196a0ba00b41896101ae29c1e72a1c600b9dfb17cc7934"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c434a0d82c4e7d3b859e91507ed0041c224de9351809f7f55dce59549a4d654"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "521adc936aa7f225156953c0dd6d8b5201d157ce1c176f2a286ea4166b87404c"
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
