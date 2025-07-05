class Readline < Formula
  desc "Library for command-line editing"
  homepage "https://tiswww.case.edu/php/chet/readline/rltop.html"
  url "https://ftp.gnu.org/gnu/readline/readline-8.3.tar.gz"
  mirror "https://ftpmirror.gnu.org/readline/readline-8.3.tar.gz"
  sha256 "fe5383204467828cd495ee8d1d3c037a7eba1389c22bc6a041f627976f9061cc"
  license "GPL-3.0-or-later"

  # Add new patches using this format:
  #
  # patch_checksum_pairs = %w[
  #   001 <checksum for 8.3.1>
  #   002 <checksum for 8.3.2>
  #   ...
  # ]

  patch_checksum_pairs = %w[]

  patch_checksum_pairs.each_slice(2) do |p, checksum|
    patch :p0 do
      url "https://ftp.gnu.org/gnu/readline/readline-8.3-patches/readline83-#{p}"
      mirror "https://ftpmirror.gnu.org/readline/readline-8.3-patches/readline83-#{p}"
      sha256 checksum
    end
  end

  # We're not using `url :stable` here because we need `url` to be a string
  # when we use it in the `strategy` block.
  livecheck do
    url :stable
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
      patches_page = Homebrew::Livecheck::Strategy.page_content(
        "https://ftp.gnu.org/gnu/readline/#{patches_directory[1]}",
      )
      next versions if patches_page[:content].blank?

      # Generate additional major.minor.patch versions from the patch files in
      # the directory and add those to the versions array
      patches_page[:content].scan(/href=.*?readline[._-]?v?\d+(?:\.\d+)*[._-]0*(\d+)["' >]/i).each do |match|
        versions << "#{newest_version.major_minor}.#{match[0]}"
      end

      versions
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "738c27ceee9a8b198f98438477ef7a513a96a965e3a434ac3aa8fb4ed76494b1"
    sha256 cellar: :any,                 arm64_sonoma:   "e46d4ff0c800dd35b9d5cef74e61ade54edc0834231f35c695af206bed9e3608"
    sha256 cellar: :any,                 arm64_ventura:  "57580f6ff00c7717c8d791a583f7837944a230c573f1fb8338fd155656be4f04"
    sha256 cellar: :any,                 arm64_monterey: "c3245660eb2d39b76441960dd6c80212debcec51de1ef4d6f86bb13d9a5f1fe3"
    sha256 cellar: :any,                 sequoia:        "becf6fdd835be191881959acd788745c1075eeb70cb1fd9ee646a3080597ea6f"
    sha256 cellar: :any,                 sonoma:         "0cf2cae0b9bb71bee1f9f9b3ab1e5dfc27b32f474db7f2d38b8b2dffd02da5ff"
    sha256 cellar: :any,                 ventura:        "62d86d4a0c7be5d568eaf5abbb6477e4c95dc1821ef232bcb45b658dbf8f9bc4"
    sha256 cellar: :any,                 monterey:       "5e5ae8819679057596a21cfde4f575d33c87db70151386d01579bc2863b948fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3fbfa1938bcf9c9c7b52089a52a9a67a70abf7ae5c00836b6ddd8f4eb5f02ba5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "099378b496dd58f6a0fdb09e4c32d2ccae5631c0b423c1df77626d844553a85f"
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
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>
      #include <readline/readline.h>

      int main()
      {
        printf("%s\\n", readline("test> "));
        return 0;
      }
    C

    system ENV.cc, "-L", lib, "test.c", "-L#{lib}", "-lreadline", "-o", "test"
    assert_equal "test> Hello, World!\nHello, World!", pipe_output("./test", "Hello, World!\n").strip
  end
end
