class Symlinks < Formula
  desc "Symbolic link maintenance utility"
  homepage "https://github.com/brandt/symlinks"
  url "https://github.com/brandt/symlinks/archive/v1.4.3.tar.gz"
  sha256 "27105b2898f28fd53d52cb6fa77da1c1f3b38e6a0fc2a66bf8a25cd546cb30b2"
  license "MIT"

  def install
    system "make", "CC=#{ENV.cc}", "symlinks"
    bin.install "symlinks"
    man.install "symlinks.8"
  end

  test do
    # write a generic file
    (testpath/"test.txt").write <<~EOS
      hello world
    EOS
    # make a full-path link, which we want symlinks to clean up
    ln_s "#{testpath}/test.txt", "#{testpath}/test2.txt"
    # do the cleanup
    system "#{bin}/symlinks", "-c", testpath
    # test that symlinks made a relative link
    assert_equal "test.txt", File.readlink("#{testpath}/test2.txt")
  end
end
