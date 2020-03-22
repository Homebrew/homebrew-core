class Redir < Formula
  desc "Port redirector"
  homepage "https://web.archive.org/web/20190817033513/sammy.net/~sammy/hacks/"
  url "https://github.com/TracyWebTech/redir/archive/2.2.1-9.tar.gz"
  version "2.2.1-9"
  sha256 "7e6612a0eee1626a0e7d9888de49b9c0fa4b7f75c5c4caca7804bf73d73f01fe"

  bottle do
    cellar :any_skip_relocation
    sha256 "a811c4d0057b6d190a615a1da5cfb6dbb7321310f41da5141397295e31ffe354" => :catalina
    sha256 "5681e33f5a5cb66759b5781989bef550558752c7cd3c1b3e4b590c5441a47082" => :mojave
    sha256 "8a94df616b4af201fe512de86ab7310bed38136397ee53b37d6f0a4a2729282e" => :high_sierra
    sha256 "cb7132731ff0121978a4e72208203d30d4fd91a10731fda2ac474619ab4472cb" => :sierra
    sha256 "6109cd43a30457b4306b701f12088b6b7c1b40dddfb592b805e5ba4eb6b56158" => :el_capitan
    sha256 "76c6d218033c27de7a5030e8d9fe1356e0a152e3a31e4210b589314643b9fd0d" => :yosemite
    sha256 "19b1d25bc23f38eeecd22c9ed2eac4640e63e97d7a192e7bc71b822d5d29afe0" => :mavericks
  end

  def install
    system "make"
    bin.install "redir"
    man1.install "redir.man"
  end

  test do
    redir_pid = fork do
      exec "#{bin}/redir", "--cport=12345", "--lport=54321"
    end
    Process.detach(redir_pid)

    nc_pid = fork do
      exec "nc -l 12345"
    end

    # Give time to processes start
    sleep(1)

    begin
      # Check if the process is running
      system "kill", "-0", redir_pid

      # Check if the port redirect works
      system "nc", "-z", "localhost", "54321"
    ensure
      Process.kill("TERM", redir_pid)
      Process.kill("TERM", nc_pid)
      Process.wait(nc_pid)
    end
  end
end
