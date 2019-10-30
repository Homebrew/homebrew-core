class Stgit < Formula
  desc "Push/pop utility built on top of Git"
  homepage "https://github.com/ctmarinas/stgit"
  url "https://github.com/ctmarinas/stgit/archive/v0.21.tar.gz"
  sha256 "ba1ccbbc15beccc4648ae3b3a198693be7e6b1b1e330f45605654d56095dac0d"
  head "https://github.com/ctmarinas/stgit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "751882c2e3156de10390ff47553956dc2d05269a420900e420735910900b156e" => :catalina
    sha256 "29fe9836395278c617b1e7086e14d2ff8f538809a2e6f919842c57f659bd4912" => :mojave
    sha256 "29fe9836395278c617b1e7086e14d2ff8f538809a2e6f919842c57f659bd4912" => :high_sierra
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
