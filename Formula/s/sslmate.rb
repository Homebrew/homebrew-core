class Sslmate < Formula
  desc "Buy SSL certs from the command-line"
  homepage "https://sslmate.com"
  url "https://packages.sslmate.com/other/sslmate-1.9.1.tar.gz"
  sha256 "179b331a7d5c6f0ed1de51cca1c33b6acd514bfb9a06a282b2f3b103ead70ce7"
  license "MIT"
  revision 2

  livecheck do
    url "https://packages.sslmate.com/other/"
    regex(/href=.*?sslmate[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a1b305211c239b3c0476b01d55bd397da45a59013ab35a1b939b1e7c43c0b32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "565aa3ae6e99d734fa430a664c3d08b6ff2301127da6b4f408009fd96a6fa384"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "565aa3ae6e99d734fa430a664c3d08b6ff2301127da6b4f408009fd96a6fa384"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "565aa3ae6e99d734fa430a664c3d08b6ff2301127da6b4f408009fd96a6fa384"
    sha256 cellar: :any_skip_relocation, sonoma:        "351e49ea1faf2c054b781097608e26a6e13e7af5259be2471993fa69d91102a2"
    sha256 cellar: :any_skip_relocation, ventura:       "351e49ea1faf2c054b781097608e26a6e13e7af5259be2471993fa69d91102a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "766551303f82f9d0d67eb302c7e9d3f40cc72d5b3a3d6ab242c61e0f60688277"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb4a80e5c90b0d869a6c6734e7c768ae81ec3112890c72034cd74071cc08b20a"
  end

  uses_from_macos "perl"

  on_linux do
    resource "URI::Escape" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.21.tar.gz"
      sha256 "96265860cd61bde16e8415dcfbf108056de162caa0ac37f81eb695c9d2e0ab77"
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
