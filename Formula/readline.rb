class Readline < Formula
  desc "Library for command-line editing"
  homepage "https://tiswww.case.edu/php/chet/readline/rltop.html"
  url "https://ftp.gnu.org/gnu/readline/readline-8.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/readline/readline-8.1.tar.gz"
  version "8.1.2"
  sha256 "f8ceb4ee131e3232226a17f51b164afc46cd0b9e6cef344be87c65962cb82b02"
  license "GPL-3.0-or-later"

  %w[
    001 682a465a68633650565c43d59f0b8cdf149c13a874682d3c20cb4af6709b9144
    002 e55be055a68cb0719b0ccb5edc9a74edcc1d1f689e8a501525b3bc5ebad325dc
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
    sha256 cellar: :any,                 arm64_monterey: "9d9d9512c80c6ae7c8281da84533222d90cb5e06accdfa98e0bff37672793cec"
    sha256 cellar: :any,                 arm64_big_sur:  "08efc469d237689a9619ec6b3ea931793d03597e89bd622ebd122b7256d7a446"
    sha256 cellar: :any,                 monterey:       "976185ec243284d74eb8b9c554d944cbc0208c26495193bcd28fdf12a08f134e"
    sha256 cellar: :any,                 big_sur:        "1eaadc077c1584e296810abbcefd2e90bc055ddbcb675f0668e86f95f2229212"
    sha256 cellar: :any,                 catalina:       "7346c1c37bfa5f9b9661450e8d7b627012dfc551813e3df48508a4fa1a05e6e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b46aff4f720e0f15601aecb2efd4ae7c2a3454b2fad91b196728ed4ee4f12c3"
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
