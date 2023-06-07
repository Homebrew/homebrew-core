class Redir < Formula
  desc "Port redirector"
  homepage "https://web.archive.org/web/20190817033513/sammy.net/~sammy/hacks/"
  url "https://github.com/TracyWebTech/redir/archive/2.2.1-9.tar.gz"
  sha256 "7e6612a0eee1626a0e7d9888de49b9c0fa4b7f75c5c4caca7804bf73d73f01fe"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "236941203f68e2338ee2e31c8fc621d97188f8961d691621ae7d4df16c7dcb8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31d05c824bc5c340c1bbd775c00bc8803a39e528f8435e78bc7ef284316ce07e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11abbdbbf74827eaf72cef5c1c2b7a84fc79010a00afc11f69b5797f44449479"
    sha256 cellar: :any_skip_relocation, ventura:        "9967e8540c4764720846ba3b592fd1ab902953194a87d2f034ed2768bd8fbd76"
    sha256 cellar: :any_skip_relocation, monterey:       "9981c02e789e34dbdf80c39509768b7f3142e25ae15a24a8830993cd40c43fd8"
    sha256 cellar: :any_skip_relocation, big_sur:        "d57505000ee6d3eafe86ede2a16d9902a11378bd9071cbd0fab1773d53bc5bfd"
    sha256 cellar: :any_skip_relocation, catalina:       "a811c4d0057b6d190a615a1da5cfb6dbb7321310f41da5141397295e31ffe354"
    sha256 cellar: :any_skip_relocation, mojave:         "5681e33f5a5cb66759b5781989bef550558752c7cd3c1b3e4b590c5441a47082"
    sha256 cellar: :any_skip_relocation, high_sierra:    "8a94df616b4af201fe512de86ab7310bed38136397ee53b37d6f0a4a2729282e"
    sha256 cellar: :any_skip_relocation, sierra:         "cb7132731ff0121978a4e72208203d30d4fd91a10731fda2ac474619ab4472cb"
    sha256 cellar: :any_skip_relocation, el_capitan:     "6109cd43a30457b4306b701f12088b6b7c1b40dddfb592b805e5ba4eb6b56158"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec29f6d41e3e9a9a8330a8e8e4b1883f6958ac14d0cdf7d126de07440b677244"
  end

  uses_from_macos "netcat" => :test

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
