class RubyInstall < Formula
  desc "Install Ruby, JRuby, Rubinius, MagLev, or mruby"
  homepage "https://github.com/postmodern/ruby-install#readme"
  url "https://github.com/postmodern/ruby-install/archive/v0.6.1.tar.gz"
  sha256 "b3adf199f8cd8f8d4a6176ab605db9ddd8521df8dbb2212f58f7b8273ed85e73"

  head "https://github.com/postmodern/ruby-install.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c710ba0d99a30f7c5466cb6f2277d6385297e6279fa8fb349e826c9b9bfecaf" => :sierra
    sha256 "38703ce6849bf87c8a67e0e1b9f093f0cba1b5d9cceb88b44fb9949ff4fafbe4" => :el_capitan
    sha256 "c2e7fd7648f01527d596f416405418bdbee463604f3013c1cd860b4e2b0543c2" => :yosemite
    sha256 "ec0f19e5ab2fb76c1449e22a412505d2061180c9bb4d89896f73316dd15a4926" => :mavericks
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ruby-install"
  end
end
