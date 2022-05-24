class Wrangler < Formula
  desc "Refactoring tool for Erlang with emacs and Eclipse integration"
  homepage "https://www.cs.kent.ac.uk/projects/wrangler/Wrangler/"
  revision 3
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
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f915678b262e74a057b4cb90417b0a8a6f486ad9cbbe0184dd602fb10c3ac3d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5a38558160ce09e6bc4aa970a96190778f36cabbc45e8ad477980f22b34e5e1"
    sha256 cellar: :any_skip_relocation, monterey:       "a7ae1958ee31f9882ff8aea67264550cbe7f8bd9350ad3d5f007aefaa490c68f"
    sha256 cellar: :any_skip_relocation, big_sur:        "709fa007e8e40d82cf7a73b79c55fcefbaf24f5d6bd8eb9cf5a4ad0168a2bcff"
    sha256 cellar: :any_skip_relocation, catalina:       "8d67285352be09f209dba8e1fe678bb9e88a77c74e5178687f890cf5ba19c8ca"
    sha256 cellar: :any_skip_relocation, mojave:         "1f122b48da35f344074d239e3d23fcf3d66e309dd0425062547d080bd3285a12"
    sha256 cellar: :any_skip_relocation, high_sierra:    "b3aa1c943b1de15308be2cf7ac540daa95b4a843788a662fcdf34ed30e2ec29d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c8a35606fb2501dd17a67ea29bcf606444c84526256e386d4351134869f60f3"
  end

  depends_on "erlang@22"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    suffixtree = Dir.glob("#{lib}/erlang/*/*/*/suffixtree").shift
    assert_predicate Pathname.new(suffixtree), :executable?, "suffixtree must be executable"
  end
end
