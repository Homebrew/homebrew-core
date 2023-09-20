class Squiid < Formula
  desc "Modular calculator written in Rust"
  homepage "https://imaginaryinfinity.net/"
  url "https://gitlab.com/ImaginaryInfinity/squiid-calculator/squiid/-/archive/${VERSION}/squiid-${VERSION}.tar.gz"
  sha256 "${SHA256SUM}"
  license "GPL-3.0-only"

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require 'pty'

    PTY.spawn("squiid") do |r, w, pid|
    begin
      # Wait for squiid to start
      sleep 1
      
      # test that math works
      w.write "(10 - 2) * (3 + 5) / 4"
      
      # send enter key
      w.write "\r"
      
      # capture the stdout into output variable
      output = ''
      loop do
      begin
        # strip off some color and style escape codes
        output += r.read_nonblock(1024).gsub(/\e\[[0-9;]+[A-Za-z]/, '')
      rescue IO::WaitReadable
        break if IO.select([r], nil, nil, 2).nil?
        retry
      rescue EOFError
        break
      end
      end
      
      # check that the calculator has done math correctly
      assert_match "(10-2)*(3+5)/4=16", output
      
      # quit
      w.write "quit"
      w.write "\r"
      
      # Wait for the TUI app to exit
      Process.wait(pid)
    rescue PTY::ChildExited
      # app exited
    end
    end
  end
end
