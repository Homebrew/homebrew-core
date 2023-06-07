class Wrangler < Formula
  desc "Refactoring tool for Erlang with emacs and Eclipse integration"
  homepage "https://www.cs.kent.ac.uk/projects/wrangler/Wrangler/"
  revision 4
  head "https://github.com/RefactoringTools/wrangler.git", branch: "master"

  stable do
    url "https://github.com/RefactoringTools/wrangler/archive/wrangler1.2.tar.gz"
    sha256 "a6a87ad0513b95bf208c660d112b77ae1951266b7b4b60d8a2a6da7159310b87"

    # upstream commit "Fix -spec's to compile in Erlang/OTP 19"
    patch do
      url "https://github.com/RefactoringTools/wrangler/commit/d81b888fd200dda17d341ec457d6786ef912b25d.patch?full_index=1"
      sha256 "b7911206315c32ee08fc89776015cf5b26c97b6cb4f6eff0b73dcf2d583cfe31"
    end

    # upstream commit "fixes to make wrangler compile with R21"
    patch do
      url "https://github.com/RefactoringTools/wrangler/commit/1149d6150eb92dcfefb91445179e7566952e184f.patch?full_index=1"
      sha256 "e84cba2ead98f47a16d9bb50182bbf3edf3ea27afefa36b78adc5afdf4aeabd5"
    end

    # upstream commit "Update to work with newest OTP"
    patch do
      url "https://github.com/RefactoringTools/wrangler/commit/d3d84879b4269759b26d009013edc5bcff49a1af.patch?full_index=1"
      sha256 "cc37f3042433d2c862f4cd4caa0d5a6b0716bdcb8f4840098ba1b46bca52f24b"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5adf04c90219783c097afa4424ca7d8c01a37a840438b73ea5477e8548c3c28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c19fcdbf860258e889a2ba69f1b406bd2d2b84e5909674797ac9c9196612668"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf4f8c3a4e10d777168307d3a0df5bc3b00b53a6bc08b18e81a9fe1ea0f01fdb"
    sha256 cellar: :any_skip_relocation, ventura:        "94ba773c98e258e54cb828a15d432a34ea8229c22d7b892075efa0875bdf2fac"
    sha256 cellar: :any_skip_relocation, monterey:       "e804d44738a3786080061ec9d1caf803d31f9f47806fa8ddb30b202b6b2bcc70"
    sha256 cellar: :any_skip_relocation, big_sur:        "66828d6127a345f7730f4079e528307058b919c7e474c207f86ae9b11457dafb"
    sha256 cellar: :any_skip_relocation, catalina:       "3a99bc85d03a60064a32c580ef2e29fc9ee1a5ea6ca121410129ff059cfd5200"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6ae31d2916213e6b6520c5ecbf68234a09182b468d8f68f95b862098b806e1a"
  end

  depends_on "erlang"

  def install
    # Work around failure from GCC 10+ using default of `-fno-common`
    # suffix_tree.o:(.bss+0x10): multiple definition of `ST_ERROR'; main.o:(.bss+0x0): first defined here
    ENV.append_to_cflags "-fcommon" if OS.linux?

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    suffixtree = Dir.glob("#{lib}/erlang/*/*/*/suffixtree").shift
    assert_predicate Pathname.new(suffixtree), :executable?, "suffixtree must be executable"
  end
end
