class Whohas < Formula
  desc "Query multiple distributions' package archives"
  homepage "http://www.philippwesche.org/200811/whohas/intro.html"
  url "https://github.com/whohas/whohas/releases/download/0.29.1/whohas-0.29.1.tar.gz"
  sha256 "dbf2396838cb0f97726041213c04426b818d48cc510bd529faf30a8411682878"

  bottle do
    cellar :any_skip_relocation
    sha256 "9d2750cb7494536df98d8df50d3ae9d6e3e48e8f12aebe4bb38c5fd8219b7f62" => :mojave
    sha256 "ad57fdefa6da7a779c1bd503f336634dc55b8f524f8e59cfa74fb2a6eba42ebd" => :high_sierra
    sha256 "0fc69ababba028f6408233021f0dfbbe6b1d29abcbce8416b8eb109c24a570d1" => :sierra
    sha256 "5b879543999158c4f55a52fdb9e643267ac1ad46aa69e56448f43799f1cce771" => :el_capitan
  end

  resource "Acme::Damn" do
    url "https://cpan.metacpan.org/authors/id/I/IB/IBB/Acme-Damn-0.08.tar.gz"
    sha256 "310d2d03ff912dcd42e4d946174099f41fe3a2dd57a497d6bd65baf1759b7e0e"
  end

  resource "forks" do
    url "https://cpan.metacpan.org/authors/id/R/RY/RYBSKEJ/forks-0.36.tar.gz"
    sha256 "61be24e44f4c6fea230e8354678beb5b7adcfefd909a47db8f0a251b0ab65993"
  end

  resource "Sys::SigAction" do
    url "https://cpan.metacpan.org/authors/id/L/LB/LBAXTER/Sys-SigAction-0.23.tar.gz"
    sha256 "c4ef6c9345534031fcbbe2adc347fc7194d47afc945e7a44fac7e9563095d353"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    bin.install "whohas"
    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])

    man1.install "usr/share/man/man1/whohas.1"
    doc.install "html_assets", "intro.html"
  end

  test do
    assert_match "NetBSD", shell_output("#{bin}/whohas whohas 2>&1")
  end
end
