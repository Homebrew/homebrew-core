class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/v0.14.7.tar.gz"
  sha256 "2d91f4ee14b24832a8e1131793fb6033aab845da64d7fc7ee8cbe5c7003b8f38"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3fd1ea3732edc1444991043ce0c81aecc7c5c623805b153a556ccb34c82d2000"
    sha256 cellar: :any_skip_relocation, big_sur:       "7a18af518650a4d510bad06f46de6377aec55da3f779c2baedccb3efbe2aa89d"
    sha256 cellar: :any_skip_relocation, catalina:      "409296537a2ac732eac8dcb2ceb9ebe62a75a62dee13adc761455e6c20663117"
    sha256 cellar: :any_skip_relocation, mojave:        "facc22aaac659aa12256c3b6eaba69ee8b5f1500cf7f573a6eba31fc4a3b077a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a952ef0ef32b3c2bd1ed5ae72f908a65112d18d6dd98fbff212956b5621aad80"
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
