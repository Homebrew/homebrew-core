class StripNondeterminism < Formula
  desc "Tool for stripping bits of non-deterministic information from files"
  homepage "https://salsa.debian.org/reproducible-builds/strip-nondeterminism"
  url "https://salsa.debian.org/reproducible-builds/strip-nondeterminism/-/archive/1.14.1/strip-nondeterminism-1.14.1.tar.bz2"
  sha256 "149e5e7585cd1d8e777564d5772fb1afa5ed7be4a049c52ffc3a31de2bc04b93"
  license "GPL-3.0-or-later"
  head "https://salsa.debian.org/reproducible-builds/strip-nondeterminism.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7917ac787a7dc6cf8d86c1b6b0fe44de78036523fec7a9c81c00c0b6dffbbac6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7917ac787a7dc6cf8d86c1b6b0fe44de78036523fec7a9c81c00c0b6dffbbac6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b09a9787d5eca23d947ca3fcf5744202051290337ee041f88af17fb70fc41c6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a853e47eb7bd6b1f321040f2debd817ab1e1291ef5df6b8381c888594d67727"
    sha256 cellar: :any_skip_relocation, ventura:       "75901bb6038f31a4afe830eee9de9c020c514d9eb6c7333ad5ed545f4bbdbe61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56debe860510e4194923c1398ccfc9b56250c2539503cb9bb1b95951a56df1d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f49f58ba6bd0bff56bbf6d0a1344f3aa46c8e2f7faf44c2b0d57b454d75488e0"
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
