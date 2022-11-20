class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/v0.20.0.tar.gz"
  sha256 "c4d63d9e1e313eeeb2e6d8d17e30b18ee4b8be01c419f08a89959fe5a4a09ac0"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ebc68fbf6aa3391e1121d66a11c98327189515987a4c8628d964c654b5c51924"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "041e9422da8ac61c2e0938b64b386b27b68545c73085eee2c3af013ea799564e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7df453f42410b4227ba15787aa915da20f4667c038a147c2c8950ef37162347"
    sha256 cellar: :any_skip_relocation, ventura:        "1fab693300aadf15740cc35cacdd92c85f7fca1f7d82895e0a1812f31478272e"
    sha256 cellar: :any_skip_relocation, monterey:       "c7cecc06360afdf1f2ce5d9b49a513e10141874f31b043f91ce6dbcd9f6729c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2094d31395093e21ae486ac0f1d72817c76b94a0233174e39b59b0c06d3266a"
    sha256 cellar: :any_skip_relocation, catalina:       "809ea7f0d2ee2dd72825f6b152fa1946ad68a1c7275e8e289b7b648b999ecf8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2687a992ba7af60549f6f0d1e8ffcd9c12a20f73d881ba89d33a225d6190ad74"
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
