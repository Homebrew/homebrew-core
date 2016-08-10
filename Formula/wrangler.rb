class Wrangler < Formula
  desc "Refactoring tool for Erlang with emacs and Eclipse integration"
  homepage "https://www.cs.kent.ac.uk/projects/wrangler/Wrangler/"
  head "https://github.com/RefactoringTools/wrangler.git"

  stable do
    url "https://github.com/RefactoringTools/wrangler/archive/wrangler1.2.tar.gz"
    sha256 "7b8700a3f8c3ef6a91d4c6ddd71e8c6cfc0816ee799a1d860a9e2955456e66f3"

    # upstream commit "Fix -spec's to compile in Erlang/OTP 19"
    patch do
      url "https://github.com/RefactoringTools/wrangler/commit/d81b888f.patch"
      sha256 "8267b2d247ea2d14255cc11dca3bef6bbe623eb34c519148ecdcf82e75be58e4"
    end
  end

  bottle do
    sha256 "9fb111bc3bf199f301205311fc2b419f4af55924d9741a43038ad01cd2d7284f" => :el_capitan
    sha256 "eba5bb8ddd5db9b8789263b21faa1c9126a4699c67326353fd5a6a22ef5b482b" => :yosemite
    sha256 "dfd60ec29bbd037decd94fd7369a5017182fb803608872b62a214381de29849c" => :mavericks
  end

  depends_on "erlang"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    suffixtree = Dir.glob("#{lib}/erlang/*/*/*/suffixtree").shift
    assert File.executable?(suffixtree), "suffixtree must be executable"
  end
end
