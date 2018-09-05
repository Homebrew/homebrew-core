class ReginaRexx < Formula
  desc "Regina REXX interpreter"
  homepage "https://regina-rexx.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/regina-rexx/regina-rexx/3.9.1/Regina-REXX-3.9.1.tar.gz"
  sha256 "5d13df26987e27f25e7779a2efa87a5775213beeda449a9efac59b57a5d5f3ee"

  bottle do
    sha256 "6b7b8db55ec8b3491edb68232d4537b3080a55953d39e05bc90e1037080656d7" => :mojave
    sha256 "26829912ce6476406e696694d27d1f758bcf3c43841969bc4f4ba4587e1fc2f4" => :high_sierra
    sha256 "9380b7c431fc2bc4cee9f3dc4997c9f7e568bc7884f3dc9aade5c2c73d805dbe" => :sierra
    sha256 "99ea4d0288bda8704830d1c1730d63e27d68a5d4e5c0c2fe2b078ba4c8e39b63" => :el_capitan
    sha256 "4be2121b50a9d988ad30b592c3123ea913a26082a2b1be7ca3ee83ae75b944d3" => :yosemite
    sha256 "6f42da795be18742801fcbf740714cf9131bcb53ce44aac50a2416b3ec7607d2" => :mavericks
    sha256 "d19717c2d929a7e0d4253e62e4d85751e0d57216d369f965b94c9ce89ff34eb5" => :mountain_lion
  end

  def install
    ENV.deparallelize # No core usage for you, otherwise race condition = missing files.
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test").write <<~EOS
      #!#{bin}/regina
      Parse Version ver
      Say ver
    EOS
    chmod 0755, testpath/"test"
    assert_match version.to_s, shell_output(testpath/"test")
  end
end
