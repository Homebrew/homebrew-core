class StripNondeterminism < Formula
  desc "Tool for stripping bits of non-deterministic information from files"
  homepage "https://salsa.debian.org/reproducible-builds/strip-nondeterminism"
  url "https://salsa.debian.org/reproducible-builds/strip-nondeterminism/-/archive/1.16.0/strip-nondeterminism-1.16.0.tar.bz2"
  sha256 "b8eac8930701cc7a975ac69e6d74ffe58d6521ee58a2f8789299c236476fc20d"
  license "GPL-3.0-or-later"
  head "https://salsa.debian.org/reproducible-builds/strip-nondeterminism.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "42dcda138fd037c31ef1e48adbe1e411b80b949bf73bed5eb5735f1a9cf42f26"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3e9a05c00065697c154e70d2b455c2fe0bfb2b7796ffa490688054cfffdad264"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3e9a05c00065697c154e70d2b455c2fe0bfb2b7796ffa490688054cfffdad264"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3e9a05c00065697c154e70d2b455c2fe0bfb2b7796ffa490688054cfffdad264"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "505c63dc80eb10187c97afd3099a28bf6e9b82cdba56b01f71cc24b1332da923"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1810c2611cb7be39a234d74533e55052fc9b7ae01858ba0bebb009763dc79db1"
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
