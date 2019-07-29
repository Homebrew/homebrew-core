class St < Formula
  desc "Statistics from the command-line"
  homepage "https://github.com/nferraz/st"
  url "https://github.com/nferraz/st/archive/v1.1.4.tar.gz"
  sha256 "c02a16f67e4c357690a5438319843149fd700c223128f9ffebecab2849c58bb8"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "8c8e5c11bd061f1a90ba17ebc19a285b4cf1494c5790ea6d7c046035ddc65956" => :mojave
    sha256 "3de383c349b1db5c6bd1d6a85f0c3637615430c55a4b2cc0f7e19208735ef221" => :high_sierra
    sha256 "cc4150103a1c9c5268355d937664401a04c2fa1ad478aa541ef7535004a75210" => :sierra
    sha256 "2df47c1388ef527487527c1173508ebdaf217b0f03c70a6e4567d037a912e214" => :el_capitan
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5/site_perl/"

    system "perl", "Makefile.PL", "PREFIX=#{libexec}"
    system "make", "install"

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files libexec/"bin", :PERL5LIB => ENV["PERL5LIB"]

    man1.install_symlink Dir[libexec/"share/man/man1/*.1"]
  end

  test do
    (testpath/"test.txt").write((1..100).map(&:to_s).join("\n"))
    assert_equal "5050", pipe_output("#{bin}/st --sum test.txt").chomp
  end
end
