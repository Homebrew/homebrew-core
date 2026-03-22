class StripNondeterminism < Formula
  desc "Tool for stripping bits of non-deterministic information from files"
  homepage "https://salsa.debian.org/reproducible-builds/strip-nondeterminism"
  url "https://salsa.debian.org/reproducible-builds/strip-nondeterminism/-/archive/1.15.0/strip-nondeterminism-1.15.0.tar.bz2"
  sha256 "cde5567a8e20f3f31ee25132d38f5803efc47c05551d321d1dd1e7666a780a07"
  license "GPL-3.0-or-later"
  head "https://salsa.debian.org/reproducible-builds/strip-nondeterminism.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c74b1e7b349d3122995ac522942d868a2eb8d4d18914a36df9a2f2a4599e986f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c74b1e7b349d3122995ac522942d868a2eb8d4d18914a36df9a2f2a4599e986f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c74b1e7b349d3122995ac522942d868a2eb8d4d18914a36df9a2f2a4599e986f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6bd8260e62ce02f163df584fbfd5335bf0209a2fd90d19c0abbed3a62146281"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f010fb1fe507739c9e008422a72e7d03b9574da8f3dbf40d361bab0808c028b"
    sha256 cellar: :any_skip_relocation, ventura:       "ec0acf9bc2af17c5698806d4e4038817eb8b97f80baa4e3e1effe3987549c665"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ff6a548bec5370e987393aa9edf3fb3a10a41409050327af3d70ae3189375a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e32a0e8ea3c0201f2e8cc448b4b7acfc759b22f14c5315466da11c6db73e2eb3"
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
