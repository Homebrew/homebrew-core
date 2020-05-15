class Wrangler < Formula
  desc "Refactoring tool for Erlang with emacs and Eclipse integration"
  homepage "https://www.cs.kent.ac.uk/projects/wrangler/Wrangler/"
  revision 3
  head "https://github.com/RefactoringTools/wrangler.git"

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
    cellar :any_skip_relocation
    sha256 "f666670522f930ed3b9412f2301bfaf6514db08c3ce48d1aa86419611dcd6783" => :catalina
    sha256 "f285e272fd51ca316f073bd5c0bbcaf285b5a0cbd453bc1f945efd67eca7c034" => :mojave
    sha256 "35f891e2ab69591e3d4bd907197b21fae3b23f9b727278e1c2cc577d10277660" => :high_sierra
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
