class Tegh < Formula
  desc "Command-line client for Prontserve"
  homepage "https://github.com/D1plo1d/tegh"
  url "https://s3.amazonaws.com/tegh_binaries/0.3.1/tegh-0.3.1-brew.tar.gz"
  sha256 "1aa9bdcc9579e8d56ab6a7b50704a1f32a6e5b8950ee2042f463b0a3b31daf4e"

  head "https://github.com/D1plo1d/tegh.git", :branch => "develop"

  bottle do
    cellar :any
    revision 1
    sha256 "6bba8517593f8aab0b7c6d17639299ac83657374469159797bf23283a5542718" => :el_capitan
    sha256 "85ea2f8a5348a8dc5fa69432bdb2de26c4192ce54f12168d18ba502059e93fd5" => :yosemite
    sha256 "041d0a30a9a5fc4d4d3a54fc7bb0b401888064a241e638f87c8d528f7cd38b62" => :mavericks
  end

  depends_on "node"

  def install
    if build.head?
      ENV.prepend_path "PATH", "#{Formula["node"].opt_libexec}/npm/bin"
      system "npm", "install"
    end

    rm "bin/tegh.bat"
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end
end
