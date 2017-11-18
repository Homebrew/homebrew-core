class Texapp < Formula
  desc "App.net client based on TTYtter"
  homepage "http://www.floodgap.com/software/texapp/"
  url "http://www.floodgap.com/software/texapp/dist0/0.6.11.txt"
  sha256 "03c3d5475dfb7877000ce238d342023aeab3d44f7bac4feadc475e501aa06051"

  bottle do
    cellar :any_skip_relocation
    sha256 "6615c40b9f733227163ad90b0082c40e7a5885c8ffa36dcb6c5892c09367c279" => :high_sierra
    sha256 "6615c40b9f733227163ad90b0082c40e7a5885c8ffa36dcb6c5892c09367c279" => :sierra
    sha256 "6615c40b9f733227163ad90b0082c40e7a5885c8ffa36dcb6c5892c09367c279" => :el_capitan
  end

  depends_on "readline" => :optional

  resource "Term::ReadLine::TTYtter" do
    url "https://cpan.metacpan.org/authors/id/C/CK/CKAISER/Term-ReadLine-TTYtter-1.4.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/C/CK/CKAISER/Term-ReadLine-TTYtter-1.4.tar.gz"
    sha256 "ac373133cee1b2122a8273fe7b4244613d0eecefe88b668bd98fe71d1ec4ac93"
  end

  def install
    bin.install "#{version}.txt" => "texapp"

    if build.with? "readline"
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
      resource("Term::ReadLine::TTYtter").stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
      bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
      chmod 0755, libexec/"bin/texapp"
    end
  end

  test do
    assert_match "trying to find cURL ...", pipe_output("#{bin}/texapp", "^C")
  end
end
