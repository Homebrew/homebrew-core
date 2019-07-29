require "language/haskell"

class Shellcheck < Formula
  include Language::Haskell::Cabal

  desc "Static analysis and lint tool, for (ba)sh scripts"
  homepage "https://www.shellcheck.net/"
  url "https://github.com/koalaman/shellcheck/archive/v0.7.0.tar.gz"
  sha256 "946cf3421ffd418f0edc380d1184e4cb08c2ec7f098c79b1c8a2c482fe91d877"
  head "https://github.com/koalaman/shellcheck.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "20539e9e7d74ca9f46d397e050343d1bee078c3a47f808682771b2edd9df3ff4" => :mojave
    sha256 "4cf8f9e649d601ff8ff0e6aa5ec942a57ced2c2d6b1aa6abf00031bf3a047e73" => :high_sierra
    sha256 "a4c362d13a746d6c3377d2970d311668626c175f8a86fe7289f9cbacbda9f59c" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pandoc" => :build

  def install
    install_cabal_package
    system "pandoc", "-s", "-f", "markdown-smart", "-t", "man",
                     "shellcheck.1.md", "-o", "shellcheck.1"
    man1.install "shellcheck.1"
  end

  test do
    sh = testpath/"test.sh"
    sh.write <<~EOS
      for f in $(ls *.wav)
      do
        echo "$f"
      done
    EOS
    assert_match "[SC2045]", shell_output("#{bin}/shellcheck -f gcc #{sh}", 1)
  end
end
