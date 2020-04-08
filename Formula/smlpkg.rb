class Smlpkg < Formula
  desc "Package manager for Standard ML libraries and programs"
  homepage "https://github.com/diku-dk/smlpkg"
  url "https://github.com/diku-dk/smlpkg/archive/v0.1.3.tar.gz"
  sha256 "cfa7eeff951e04df428694fda38917ee2aaaf0532e2d1dbea7ab4c150f4fe2f0"
  head "https://github.com/diku-dk/smlpkg.git"

  depends_on "mlkit"

  def install
    system "make", "-C", "src", "smlpkg"
    system "make", "install", "INSTALLDIR=#{bin}"
  end

  test do
    (testpath/"sml.pkg.ok").write <<~EOS
      package github.com/diku-dk/testpkg

      require {
      }
    EOS
    system "#{bin}/smlpkg", "init", "github.com/diku-dk/testpkg"
    assert_equal "", shell_output("diff sml.pkg sml.pkg.ok")
  end
end
