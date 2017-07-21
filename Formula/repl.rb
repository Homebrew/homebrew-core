class Repl < Formula
  desc "Wrap non-interactive programs with a REPL"
  homepage "https://github.com/pvdb/repl"
  url "https://github.com/pvdb/repl/archive/v2.0.0.tar.gz"
  sha256 "4cf4f98b6bec99f031e1ac6a7176d1b38022557a7ea3dd046eae55a1e7c93cd5"

  bottle :unneeded

  depends_on "rlwrap" => :optional

  def install
    bin.install "bin/repl"
    man1.install "man/repl.1"
  end

  test do
    pipe_output("#{bin}/repl git", "init", 0)
  end
end
