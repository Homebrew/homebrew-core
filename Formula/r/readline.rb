class Readline < Formula
  desc "Library for command-line editing"
  homepage "https://tiswww.case.edu/php/chet/readline/rltop.html"
  url "https://ftpmirror.gnu.org/readline/readline-8.3.tar.gz"
  mirror "https://ftp.gnu.org/gnu/readline/readline-8.3.tar.gz"
  version "8.3.6"
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
    004 1f189c4566aa35950964647b9ec3be1a821e42b86048129c63eb7f9d4d2f5a74
    005 5481adbe161c9f6ba972c74db9e18c7aa351d3df3035cc4a673a1aa06247d1c6
    006 4ebd261a608287796e171af0ea9af5a1e3122e46672accda2484b6698c47c1a4
  ]

  patch_checksum_pairs.each_slice(2) do |p, checksum|
    patch :p0 do
      url "https://ftpmirror.gnu.org/readline/readline-8.3-patches/readline83-#{p}"
      mirror "https://ftp.gnu.org/gnu/readline/readline-8.3-patches/readline83-#{p}"
      sha256 checksum
      type :cherry_pick
    end
  end
  compatibility_version 1

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
        "https://ftpmirror.gnu.org/readline/#{patches_directory[1]}",
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
    sha256 cellar: :any, arm64_golden_gate: "74b458562c5a589a612ebba8f8fc12f3ecbe083223eb4a368c723d88b26a454d"
    sha256 cellar: :any, arm64_tahoe:       "15cdd69af824537192843db389cbfd2459b3797cf4f36c906f8f8ab617d7d59f"
    sha256 cellar: :any, arm64_sequoia:     "461763fa21c050a59e5bbceedf67dcacf24e4aa4604490d73f0c9fa0f40e7fe5"
    sha256 cellar: :any, arm64_linux:       "ba75518e6b5d5376aa56fe6754deaf9188cf5df9b24f5885dbf0baf8e27a5bbe"
    sha256 cellar: :any, x86_64_linux:      "4edcc5d53fb104818fd0e642f18edaace69e60c24b5e892df2bd437670c32857"
  end

  keg_only :shadowed_by_macos, "macOS provides BSD libedit"

  uses_from_macos "ncurses"

  deny_network_access!

  def install
    system "./configure", "--with-curses", *std_configure_args
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
