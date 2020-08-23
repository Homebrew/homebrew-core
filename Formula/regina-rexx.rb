class ReginaRexx < Formula
  desc "Regina REXX interpreter"
  homepage "https://regina-rexx.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/regina-rexx/regina-rexx/3.9.3/regina-rexx-3.9.3.tar.gz"
  sha256 "1712aabee5978fdf57aeac82cd5a1a112b8980db8c5d7d045523f6a8b74b0531"

  bottle do
    sha256 "7d39d4158fe41ecbd85c8c05f27d1b291883730ae1b745e1920e14ab41dfa0dc" => :catalina
    sha256 "396fe213db316516ff28a135217b9c660969244494cb8807111e71b37d5451c9" => :mojave
    sha256 "c8e204d8fb1154c31a4be3d571f4bbcc9e9b9ec5406feb61be82f7c567f9c8a7" => :high_sierra
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
