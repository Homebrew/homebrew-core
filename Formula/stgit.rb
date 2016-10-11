class Stgit < Formula
  desc "Push/pop utility built on top of Git"
  homepage "https://gna.org/projects/stgit/"
  url "http://download.gna.org/stgit/stgit-0.17.1.tar.gz"
  sha256 "d43365a0c22e41a6fb9ba1a86de164d6475e79054e7f33805d6a829eb4056ade"

  head "git://repo.or.cz/stgit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b2a1aeef8a0c4540ad334d8397175faf34dc190d5f562769cf23c300c5590998" => :sierra
    sha256 "f35660d62e8d2e2e22ac12e9d5ed79c2025653e966fc754ab3cebd030108348e" => :el_capitan
    sha256 "c68c1eec9a26025d42512edaf2ab56e5fb97dfeaf06c8b6a5fbe3f314eafd930" => :yosemite
    sha256 "018e8cc3fb31adaf97467324f77694f75681b2bdb1299f9007f995fa4bfa9519" => :mavericks
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
