class Woof < Formula
  desc "Ad-hoc single-file webserver"
  homepage "http://www.home.unix-ag.org/simon/woof.html"
  url "http://www.home.unix-ag.org/simon/woof-2012-05-31.py"
  version "20120531"
  sha256 "d84353d07f768321a1921a67193510bf292cf0213295e8c7689176f32e945572"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "854310e14cd958d44e42c8b6dd5aac3ca360ae2154763a0967cfbe4dee76a512"
  end

  def install
    bin.install "woof-2012-05-31.py" => "woof"
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/woof", "-s", "-p", port.to_s
    end

    sleep 2

    begin
      read = (bin/"woof").read
      assert_equal read, shell_output("curl localhost:#{port}/woof")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
