class RubyInstall < Formula
  desc "Install Ruby, JRuby, Rubinius, TruffleRuby, or mruby"
  homepage "https://github.com/postmodern/ruby-install#readme"
  url "https://github.com/postmodern/ruby-install/archive/v0.8.1.tar.gz"
  sha256 "d96fce7a4df70ca7a367400fbe035ff5b518408fc55924966743abf66ead7771"
  license "MIT"
  head "https://github.com/postmodern/ruby-install.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd8726c3703f3132ef342e98d197a5d46d3adb6dc7db88a25b2e01ea2eafaeb8" => :big_sur
    sha256 "5d20763bbc1b77c06ab3615cdfb9d7df20ea8a933371d8b086146640bf806526" => :catalina
    sha256 "89972ce4292a039d6cd446756f0f64cd979081a79dcaba795e9b1b880027c37c" => :mojave
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ruby-install"
  end
end
