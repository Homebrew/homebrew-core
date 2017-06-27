class St < Formula
  desc "Statistics from the command-line"
  homepage "https://github.com/nferraz/st"
  url "https://github.com/nferraz/st/archive/v1.1.4.tar.gz"
  sha256 "c02a16f67e4c357690a5438319843149fd700c223128f9ffebecab2849c58bb8"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d76d1f4e18e104d8a596cb98d0e6368993f4d055cfffa28465310039646efd2e" => :sierra
    sha256 "39e686d653b963ca9bc3a306af5cd11f2d456075de10dfcec6161bb647226ef2" => :el_capitan
    sha256 "66fae854539976ced286c31719cf038599ae0e2767d6c268dd9bc554c879beea" => :yosemite
    sha256 "80f77d2a895dfce0e451ebbe6b8e5b9ac930e460e0745b12789d7cfce57eaf8f" => :mavericks
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5/site_perl/"

    system "perl", "Makefile.PL", "PREFIX=#{libexec}"
    system "make", "install"

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files libexec/"bin", :PERL5LIB => ENV["PERL5LIB"]
  end

  test do
    (testpath/"test.txt").write((1..100).map(&:to_s).join("\n"))
    assert_equal "5050", pipe_output("#{bin}/st --sum test.txt").chomp
  end
end
