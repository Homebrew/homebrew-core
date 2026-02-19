class Readline < Formula
  desc "Library for command-line editing"
  homepage "https://tiswww.case.edu/php/chet/readline/rltop.html"
  url "https://ftpmirror.gnu.org/gnu/readline/readline-8.3.tar.gz"
  mirror "https://ftp.gnu.org/gnu/readline/readline-8.3.tar.gz"
  version "8.3.3"
  sha256 "fe5383204467828cd495ee8d1d3c037a7eba1389c22bc6a041f627976f9061cc"
  license "GPL-3.0-or-later"

  # Add new patches using this format:
  #
  # patch_checksum_pairs = %w[
  #   001 <checksum for <major>.<minor>.1>
  #   002 <checksum for <major>.<minor>.2>
  #   ...
  # ]

  patch_checksum_pairs = %w[
    001 21f0a03106dbe697337cd25c70eb0edbaa2bdb6d595b45f83285cdd35bac84de
    002 e27364396ba9f6debf7cbaaf1a669e2b2854241ae07f7eca74ca8a8ba0c97472
    003 72dee13601ce38f6746eb15239999a7c56f8e1ff5eb1ec8153a1f213e4acdb29
  ]

  patch_checksum_pairs.each_slice(2) do |p, checksum|
    patch :p0 do
      url "https://ftpmirror.gnu.org/gnu/readline/readline-8.3-patches/readline83-#{p}"
      mirror "https://ftp.gnu.org/gnu/readline/readline-8.3-patches/readline83-#{p}"
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
        "https://ftpmirror.gnu.org/gnu/readline/#{patches_directory[1]}",
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
    sha256 cellar: :any,                 arm64_tahoe:   "1c6234c033c83ea742d50aa45fd60821947fa800d5cadecb0a1aa045564bb7d1"
    sha256 cellar: :any,                 arm64_sequoia: "2e055f7b620fcbe1f809e850a23a68daa429edcf9b484b1967f9a49d89ebed8e"
    sha256 cellar: :any,                 arm64_sonoma:  "15440b045b3e8294c8cbb819b32ba26520ce53b18bf947166a21a38e34662d84"
    sha256 cellar: :any,                 tahoe:         "67a24889119e6429144cd15fb9b0dc8ae37cf272388605a5780bb734f8e6b093"
    sha256 cellar: :any,                 sequoia:       "fd72a581442e1826e1386b8620e6ca5b75d858ded59d9fe60b9e0e9001675dc3"
    sha256 cellar: :any,                 sonoma:        "614b89ff043bb59540c284dc696aedb1ffe30c4cc902d4e27b088ebaa3dc9312"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cbd86f40534c4ef8b800e605408411bc6b047bf7c4f3911b2c020b1cfa39b89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea989e13a1df95ab899b8b1d35713def4330950259e7a48053fcd7967ee316b2"
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
