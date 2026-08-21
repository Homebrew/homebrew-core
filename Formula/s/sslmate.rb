class Sslmate < Formula
  desc "Buy SSL certs from the command-line"
  homepage "https://sslmate.com"
  url "https://packages.sslmate.com/other/sslmate-1.10.0.tar.gz"
  sha256 "ca378afc28c54a38f29ab8956f8d405b2d12489e66c0fa7a4fe6acc8769e5f91"
  license "MIT"
  revision 1

  livecheck do
    url "https://packages.sslmate.com/other/"
    regex(/href=.*?sslmate[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60ca144e9ecce60f4898bc68699d18242f1e362264cfde911cf0b9267810b10f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60ca144e9ecce60f4898bc68699d18242f1e362264cfde911cf0b9267810b10f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60ca144e9ecce60f4898bc68699d18242f1e362264cfde911cf0b9267810b10f"
    sha256 cellar: :any_skip_relocation, tahoe:         "60ca144e9ecce60f4898bc68699d18242f1e362264cfde911cf0b9267810b10f"
    sha256 cellar: :any_skip_relocation, sequoia:       "60ca144e9ecce60f4898bc68699d18242f1e362264cfde911cf0b9267810b10f"
    sha256 cellar: :any_skip_relocation, sonoma:        "60ca144e9ecce60f4898bc68699d18242f1e362264cfde911cf0b9267810b10f"
    sha256 cellar: :any,                 arm64_linux:   "79b8257c55848f303331a682bb3d99cf2a67f385fc39074bddd9500927ad5e1e"
    sha256 cellar: :any,                 x86_64_linux:  "daf31006d6a1f25a880cc132bbf25daffe4d31c53f9c381dcb28dc8e57a4e478"
  end

  uses_from_macos "perl"

  on_linux do
    resource "URI::Escape" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.34.tar.gz"
      sha256 "de64c779a212ff1821896c5ca2bb69e74767d2674cee411e777deea7a22604a8"
    end

    resource "Term::ReadKey" do
      url "https://cpan.metacpan.org/authors/id/J/JS/JSTOWE/TermReadKey-2.38.tar.gz"
      sha256 "5a645878dc570ac33661581fbb090ff24ebce17d43ea53fd22e105a856a47290"
    end
  end

  def install
    if OS.linux?
      ENV.prepend_create_path "PERL5LIB", libexec/"vendor/lib/perl5"

      resources.each do |r|
        r.stage do
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}/vendor"
          system "make"
          system "make", "install"
        end
      end
    end

    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"]) if OS.linux?
  end

  test do
    system bin/"sslmate", "req", "www.example.com"
    # Make sure well-formed files were generated:
    system "openssl", "rsa", "-in", "www.example.com.key", "-noout"
    system "openssl", "req", "-in", "www.example.com.csr", "-noout"
    # The version command tests the HTTP client:
    system bin/"sslmate", "version"
  end
end
