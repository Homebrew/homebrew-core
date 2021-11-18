class Readline < Formula
  desc "Library for command-line editing"
  homepage "https://tiswww.case.edu/php/chet/readline/rltop.html"
  url "https://ftp.gnu.org/gnu/readline/readline-8.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/readline/readline-8.1.tar.gz"
  version "8.1.1"
  sha256 "f8ceb4ee131e3232226a17f51b164afc46cd0b9e6cef344be87c65962cb82b02"
  license "GPL-3.0-or-later"

  %w[
    001 682a465a68633650565c43d59f0b8cdf149c13a874682d3c20cb4af6709b9144
  ].each_slice(2) do |p, checksum|
    patch :p0 do
      url "https://ftp.gnu.org/gnu/readline/readline-8.1-patches/readline81-#{p}"
      mirror "https://ftpmirror.gnu.org/readline/readline-8.1-patches/readline81-#{p}"
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
    sha256 cellar: :any,                 arm64_monterey: "3b5aa5bdfee4d377f6b5d571fcadcdfa14f9973895bcf5197fcd546424b59e8b"
    sha256 cellar: :any,                 arm64_big_sur:  "bcb228b99fcecebf6ecc2b2ac80ab96a396374a8d5bc13b21034ef501017254f"
    sha256 cellar: :any,                 monterey:       "5c8cc72b8b4eb97f2e6f4fd1db5512cd1f72f71fa4a9cbdc27cac7ed6c27dae2"
    sha256 cellar: :any,                 big_sur:        "c596199dc30f2542144a10f10ac686e441bebc5707bb63cca34159e55de66e3b"
    sha256 cellar: :any,                 catalina:       "7a6136c28be474faf630922495ca617ecad1275baa4ef8646bbc31eece3809f4"
    sha256 cellar: :any,                 mojave:         "0af6c77e4e554d9ee9f60f7c55ccde1cee46aa916ce8baff66ae10ed1ef13ed1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bb1e20aafd3dfc3076b62d8f55db867edd93cbfaeb44d1d03f1968fc51209d9"
  end

  keg_only :shadowed_by_macos, "macOS provides BSD libedit"

  uses_from_macos "ncurses"

  def install
    args = ["--prefix=#{prefix}"]
    args << "--with-curses" if OS.linux?
    system "./configure", *args

    args = []
    args << "SHLIB_LIBS=-lcurses" if OS.linux?
    # There is no termcap.pc in the base system, so we have to comment out
    # the corresponding Requires.private line.
    # Otherwise, pkg-config will consider the readline module unusable.
    inreplace "readline.pc", /^(Requires.private: .*)$/, "# \\1"
    system "make", "install", *args
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
    assert_equal "test> Hello, World!\nHello, World!",
      pipe_output("./test", "Hello, World!\n").strip
  end
end
