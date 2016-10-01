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
    sha256 "89663c4a49437fdd27f2446d829e1ef7c9ae4452280f8d087d71c3a89e5c319f" => :sierra
    sha256 "dfa0d430822b57df1c044ab395d347c81311346aaa102e4097e05c7c42f38b32" => :el_capitan
    sha256 "45df8699e1ba28596cfe6395a321b56213aa5cfd6545ea0a5bafcce39e9574dd" => :yosemite
    sha256 "6296e18bc0641ba1b20becdb16f4aabc500069999a2a23c487cd98d8309855c2" => :mavericks
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
