class Stgit < Formula
  desc "Push/pop utility built on top of Git"
  homepage "https://github.com/ctmarinas/stgit"
  url "https://github.com/ctmarinas/stgit/archive/v0.21.tar.gz"
  sha256 "ba1ccbbc15beccc4648ae3b3a198693be7e6b1b1e330f45605654d56095dac0d"
  head "https://github.com/ctmarinas/stgit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "736d0fb7ba2e2f09acb9f3c12e7a232d975c1f20306b1d6b56dbc8fa9622bb0e" => :catalina
    sha256 "a8c5a52941bb5c524f97bddf295dbf65b79ec74b4ec5a0d0ebcdb25429e1e03d" => :mojave
    sha256 "a8c5a52941bb5c524f97bddf295dbf65b79ec74b4ec5a0d0ebcdb25429e1e03d" => :high_sierra
  end

  def install
    ENV["PYTHON"] = "python" # overrides 'python2' built into makefile
    system "make", "prefix=#{prefix}", "all"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    system "git", "init"
    (testpath/"test").write "test"
    system "git", "add", "test"
    system "git", "commit", "--message", "Initial commit", "test"
    system "#{bin}/stg", "init"
    system "#{bin}/stg", "log"
  end
end
