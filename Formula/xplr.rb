class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/v0.21.1.tar.gz"
  sha256 "c4befb29d862bfaaaaae35da030785782a5d2aabb4b5859974d931ccf468069a"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9e5e382e6581171e823d219db6c1204db8089d5f94ee7341c4f50821e38c5fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8611cba347e000836c3fa7c79d84e5c51f7f9028098deb7d8d8b71c95ce3d2d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27007841f69e199b785bf14f1ccdb87fea8afb00be348c311f3be6b0630e58af"
    sha256 cellar: :any_skip_relocation, ventura:        "00a0d0ffec54298e124c620a6eb35b39ddfec2deb4fc0eae6739996ffd0e202c"
    sha256 cellar: :any_skip_relocation, monterey:       "273bdbee27c92b6377c0b8a489cadb18d967a391bcafd01bb19b1ae7edfd8815"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ba861c02ba0146d0367a3c787553b721896650515de04189a3816287ec97a55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28f518f272f17fbe4bcf7929268398817e179c64b69e36210783e051c64b546d"
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
