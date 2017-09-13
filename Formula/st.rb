class St < Formula
  desc "Statistics from the command-line"
  homepage "https://github.com/nferraz/st"
  url "https://github.com/nferraz/st/archive/v1.1.4.tar.gz"
  sha256 "c02a16f67e4c357690a5438319843149fd700c223128f9ffebecab2849c58bb8"

  bottle do
    cellar :any_skip_relocation
    sha256 "55e719bafc7c95b7a52111c55d1df8845237a723370bc69ab099321cc555ec0d" => :sierra
    sha256 "4c8d388a914a238851b44beff95a1e75523c406e5731d3e894dcda324c260a82" => :el_capitan
    sha256 "05b683f39a6b30d377d4217e5145369053014f8f66b6dd103fb2ee2219aa4225" => :yosemite
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
