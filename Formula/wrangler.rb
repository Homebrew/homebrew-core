class Wrangler < Formula
  desc "Refactoring tool for Erlang with emacs and Eclipse integration"
  homepage "https://www.cs.kent.ac.uk/projects/wrangler/Wrangler/"
  revision 1
  head "https://github.com/RefactoringTools/wrangler.git"

  stable do
    url "https://github.com/RefactoringTools/wrangler/archive/wrangler1.2.tar.gz"
    sha256 "a6a87ad0513b95bf208c660d112b77ae1951266b7b4b60d8a2a6da7159310b87"

    # upstream commit "Fix -spec's to compile in Erlang/OTP 19"
    patch do
      url "https://github.com/RefactoringTools/wrangler/commit/d81b888f.patch?full_index=1"
      sha256 "b7911206315c32ee08fc89776015cf5b26c97b6cb4f6eff0b73dcf2d583cfe31"
    end
  end

  bottle do
    sha256 "529f9eaef03fd452c23ffe017a40b4d7a3b6b0916c8bf703a2dcde5928e0b172" => :mojave
    sha256 "a28a2a7468aa9a3f058efaa22dd0f62e54288b19c4b6bae894e036354eb14eba" => :high_sierra
    sha256 "82c65deab497486889357ba5c68cd184bea168bc91a12de58f5aac9b17ea2b68" => :sierra
    sha256 "fa0957e38733763091ee1e4bee98d7b2fab221fff49416d6eb7950374ce5df3d" => :el_capitan
  end

  depends_on "erlang@20"

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
