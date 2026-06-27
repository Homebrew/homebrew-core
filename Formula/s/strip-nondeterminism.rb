class StripNondeterminism < Formula
  desc "Tool for stripping bits of non-deterministic information from files"
  homepage "https://salsa.debian.org/reproducible-builds/strip-nondeterminism"
  url "https://salsa.debian.org/reproducible-builds/strip-nondeterminism/-/archive/1.15.1/strip-nondeterminism-1.15.1.tar.bz2"
  sha256 "b8046b0faf182aff8de68abf8318d2b913637f4c23961cf61c47402af132a237"
  license "GPL-3.0-or-later"
  head "https://salsa.debian.org/reproducible-builds/strip-nondeterminism.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5617490e121fbfcfe36da186cf360283e68c32a79f84f2b968b8201665bd0c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5617490e121fbfcfe36da186cf360283e68c32a79f84f2b968b8201665bd0c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5617490e121fbfcfe36da186cf360283e68c32a79f84f2b968b8201665bd0c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "72f86521bfa1a5a6ef717e931233fbb05be094b7ec7422022c29c85b315af68a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da0f43e5ea970635fadb6bbefc82f2d9cdc6d467eddd83ad385fba5f785846bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a75128c656e8c8b5a75ec7c0a2947b32d75ff31c737588dc78ecd3a2ff6afaad"
  end

  uses_from_macos "file-formula" => :test
  uses_from_macos "perl"

  # NOTE: Getopt::Long is included with Perl. Archive::Zip is included with macOS

  resource "Archive::Cpio" do
    url "https://cpan.metacpan.org/authors/id/P/PI/PIXEL/Archive-Cpio-0.10.tar.gz"
    sha256 "246fb31669764e78336b2191134122e07c44f2d82dc4f37d552ab28f8668bed3"
  end

  resource "Archive::Zip" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/P/PH/PHRED/Archive-Zip-1.68.tar.gz"
      sha256 "984e185d785baf6129c6e75f8eb44411745ac00bf6122fb1c8e822a3861ec650"
    end
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV.prepend_path "PERL5LIB", libexec/"lib"

    resources.each do |r|
      r.stage do
        if File.exist?("Makefile.PL")
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}", "NO_MYMETA=1"
          system "make", "install"
        else
          system "perl", "Build.PL", "--install_base", libexec
          system "./Build"
          system "./Build", "install"
        end
      end
    end

    system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
    system "make"
    system "make", "install"

    (bin/"strip-nondeterminism").write_env_script libexec/"bin/strip-nondeterminism", PERL5LIB: ENV["PERL5LIB"]
    man1.install_symlink libexec/"man/man1/strip-nondeterminism.1"
  end

  test do
    (testpath/"test.txt").write "Hello world"
    system "gzip", "test.txt"
    system bin/"strip-nondeterminism", "--timestamp", "1", "--verbose", "test.txt.gz"
    assert_match(/Thu\s+Jan\s+1\s+00:00:01\s+1970/, shell_output("file test.txt.gz"))
  end
end
