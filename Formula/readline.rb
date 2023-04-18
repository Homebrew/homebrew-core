class Readline < Formula
  desc "Library for command-line editing"
  homepage "https://tiswww.case.edu/php/chet/readline/rltop.html"
  url "https://ftp.gnu.org/gnu/readline/readline-8.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/readline/readline-8.2.tar.gz"
  version "8.2.1"
  sha256 "3feb7171f16a84ee82ca18a36d7b9be109a52c04f492a053331d7d1095007c35"
  license "GPL-3.0-or-later"

  %w[
    001 bbf97f1ec40a929edab5aa81998c1e2ef435436c597754916e6a5868f273aff7
  ].each_slice(2) do |p, checksum|
    patch :p0 do
      url "https://ftp.gnu.org/gnu/readline/readline-8.2-patches/readline82-#{p}"
      mirror "https://ftpmirror.gnu.org/readline/readline-8.2-patches/readline82-#{p}"
      sha256 checksum
    end
  end

  # We're not using `url :stable` here because we need `url` to be a string
  # when we use it in the `strategy` block.
  livecheck do
    url "https://ftp.gnu.org/gnu/readline/"
    regex(/href=.*?readline[._-]v?(\d+(?:\.\d+)+)\.t/i)
    strategy :gnu do |page, regex|
      # Match versions from files
      versions = page.scan(regex)
                     .flatten
                     .uniq
                     .map { |v| Version.new(v) }
                     .sort
      next versions if versions.blank?

      # Assume the last-sorted version is newest
      newest_version = versions.last

      # Simply return the found versions if there isn't a patches directory
      # for the "newest" version
      patches_directory = page.match(%r{href=.*?(readline[._-]v?#{newest_version.major_minor}[._-]patches/?)["' >]}i)
      next versions if patches_directory.blank?

      # Fetch the page for the patches directory
      patches_page = Homebrew::Livecheck::Strategy.page_content(URI.join(@url, patches_directory[1]).to_s)
      next versions if patches_page[:content].blank?

      # Generate additional major.minor.patch versions from the patch files in
      # the directory and add those to the versions array
      patches_page[:content].scan(/href=.*?readline[._-]?v?\d+(?:\.\d+)*[._-]0*(\d+)["' >]/i).each do |match|
        versions << "#{newest_version.major_minor}.#{match[0]}"
      end

      versions
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fba42a9bd6feaa8902ae4491ffdf177662e0a165a0d0ddef0988ad6ecf0f23dd"
    sha256 cellar: :any,                 arm64_monterey: "9406afa0f7aefbbef37ee193b3b17dd0e08bb2a80e99680cde732289f4819ad2"
    sha256 cellar: :any,                 arm64_big_sur:  "7012f0f3d05e9ca181c67bd55ffeee000aa557aedcee0e260d75085215e80234"
    sha256 cellar: :any,                 ventura:        "abe9d3f3eec3ba2339860faa6a978b9909194c65c97a60b0d16f3d6d118879ea"
    sha256 cellar: :any,                 monterey:       "19e6b02f577010a1a33c6ae6f09e40772d6ab22d94b6cf3455cfed9d301d28cf"
    sha256 cellar: :any,                 big_sur:        "e6dfc7d95895f18657c0fb15e77a8c104362bb87bafdff770a6a352301cc1082"
    sha256 cellar: :any,                 catalina:       "ef32c6905cc91e0ff5acfce9ad9e7aba1eecbcc5c79ee4e1e3abfe25fa4bf1a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7dc8f7ebbfcb22adcd5535a8da083ed8aa3c42c8579c465a2263d778868bc058"
  end

  keg_only :shadowed_by_macos, "macOS provides BSD libedit"

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-curses"
    # FIXME: Setting `SHLIB_LIBS` should not be needed, but, on Linux,
    #        many dependents expect readline to link with ncurses and
    #        are broken without it. Readline should be agnostic about
    #        the terminfo library on Linux.
    system "make", "install", "SHLIB_LIBS=-lcurses"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <readline/readline.h>

      int main()
      {
        printf("%s\\n", readline("test> "));
        return 0;
      }
    EOS

    system ENV.cc, "-L", lib, "test.c", "-L#{lib}", "-lreadline", "-o", "test"
    assert_equal "test> Hello, World!\nHello, World!", pipe_output("./test", "Hello, World!\n").strip
  end
end
