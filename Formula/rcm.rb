class Rcm < Formula
  desc "RC file (dotfile) management"
  homepage "https://thoughtbot.github.io/rcm/rcm.7.html"
  url "https://thoughtbot.github.io/rcm/dist/rcm-1.3.3.tar.gz"
  sha256 "935524456f2291afa36ef815e68f1ab4a37a4ed6f0f144b7de7fb270733e13af"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/".gitconfig").write <<~EOS
      [user]
      	name = Test User
      	email = test@test.com
    EOS
    assert_match /[Moving|Linking].../x, shell_output("#{bin}/mkrc -v ~/.gitconfig")
  end
end
