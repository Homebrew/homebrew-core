class Vit < Formula
  desc "Front-end for Task Warrior"
  homepage "https://taskwarrior.org/news/news.20140406.html"
  url "https://github.com/scottkosty/vit/archive/v1.3.tar.gz"
  sha256 "a53021cfbcc1b1a492f630650e7e798d2361beb312d33ee15840e8209c8414c9"
  head "https://github.com/scottkosty/vit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dabf6d97c4af518bad19d873777ead55122b44656eaf49735966f900c225cbac" => :mojave
    sha256 "ac57f8e4f66af27f973736de36a02ba7e2f08cc4b729a904e8fe960b2ed30341" => :high_sierra
    sha256 "7b41d373de2b877ec5b91b47e36b694ea3e966822e77697948e91861dd52725c" => :sierra
  end

  depends_on "task"

  resource "Curses" do
    url "https://cpan.metacpan.org/authors/id/G/GI/GIRAFFED/Curses-1.36.tar.gz"
    sha256 "a414795ba031c5918c70279fe534fee594a96ec4b0c78f44ce453090796add64"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec+"lib/perl5"

    resource("Curses").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make", "build"

    bin.install "vit"
    man1.install "vit.1"
    man5.install "vitrc.5"
    # vit-commands needs to be installed in the keg because that's where vit
    # will look for it.
    (prefix+"etc").install "commands" => "vit-commands"
    bin.env_script_all_files(libexec+"bin", :PERL5LIB => ENV["PERL5LIB"])
  end
end
