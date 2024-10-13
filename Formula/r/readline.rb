class Readline < Formula
  desc "Library for command-line editing"
  homepage "https://tiswww.case.edu/php/chet/readline/rltop.html"
  url "https://ftp.gnu.org/gnu/readline/readline-8.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/readline/readline-8.2.tar.gz"
  version "8.2.13"
  sha256 "3feb7171f16a84ee82ca18a36d7b9be109a52c04f492a053331d7d1095007c35"
  license "GPL-3.0-or-later"

  %w[
    001 bbf97f1ec40a929edab5aa81998c1e2ef435436c597754916e6a5868f273aff7
    002 e06503822c62f7bc0d9f387d4c78c09e0ce56e53872011363c74786c7cd4c053
    003 24f587ba46b46ed2b1868ccaf9947504feba154bb8faabd4adaea63ef7e6acb0
    004 79572eeaeb82afdc6869d7ad4cba9d4f519b1218070e17fa90bbecd49bd525ac
    005 622ba387dae5c185afb4b9b20634804e5f6c1c6e5e87ebee7c35a8f065114c99
    006 c7b45ff8c0d24d81482e6e0677e81563d13c74241f7b86c4de00d239bc81f5a1
    007 5911a5b980d7900aabdbee483f86dab7056851e6400efb002776a0a4a1bab6f6
    008 a177edc9d8c9f82e8c19d0630ab351f3fd1b201d655a1ddb5d51c4cee197b26a
    009 3d9885e692e1998523fd5c61f558cecd2aafd67a07bd3bfe1d7ad5a31777a116
    010 758e2ec65a0c214cfe6161f5cde3c5af4377c67d820ea01d13de3ca165f67b4c
    011 e0013d907f3a9e6482cc0934de1bd82ee3c3c4fd07a9646aa9899af237544dd7
    012 6c8adf8ed4a2ca629f7fd11301ed6293a6248c9da0c674f86217df715efccbd3
    013 1ea434957d6ec3a7b61763f1f3552dad0ebdd6754d65888b5cd6d80db3a788a8
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

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "738c27ceee9a8b198f98438477ef7a513a96a965e3a434ac3aa8fb4ed76494b1"
    sha256 cellar: :any,                 arm64_sonoma:   "e46d4ff0c800dd35b9d5cef74e61ade54edc0834231f35c695af206bed9e3608"
    sha256 cellar: :any,                 arm64_ventura:  "57580f6ff00c7717c8d791a583f7837944a230c573f1fb8338fd155656be4f04"
    sha256 cellar: :any,                 arm64_monterey: "c3245660eb2d39b76441960dd6c80212debcec51de1ef4d6f86bb13d9a5f1fe3"
    sha256 cellar: :any,                 sequoia:        "becf6fdd835be191881959acd788745c1075eeb70cb1fd9ee646a3080597ea6f"
    sha256 cellar: :any,                 sonoma:         "0cf2cae0b9bb71bee1f9f9b3ab1e5dfc27b32f474db7f2d38b8b2dffd02da5ff"
    sha256 cellar: :any,                 ventura:        "62d86d4a0c7be5d568eaf5abbb6477e4c95dc1821ef232bcb45b658dbf8f9bc4"
    sha256 cellar: :any,                 monterey:       "5e5ae8819679057596a21cfde4f575d33c87db70151386d01579bc2863b948fd"
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
