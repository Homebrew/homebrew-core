class ShenSbcl < Formula
  desc "Shen for Steel Bank Common Lisp"
  homepage "https://github.com/Shen-Language/shen-cl"
  url "https://github.com/Shen-Language/shen-cl/archive/v2.5.0.tar.gz"
  sha256 "366225b7df60be56d7622180332bf2db9ddac087c4497ed14eeb7533a765964d"

  depends_on "sbcl" => :build

  resource "shen-kernel" do
    url "https://github.com/Shen-Language/shen-sources/releases/download/shen-21.1/ShenOSKernel-21.1.tar.gz"
    sha256 "b71dcaa0289e64b9ef7e19f11502ad47f013bb572871498feccf3cd555d5cf69"
  end

  def install
    ENV.deparallelize
    resource("shen-kernel").stage buildpath/"kernel"
    system "make", "build-sbcl"
    mv "bin/sbcl/shen", "bin/sbcl/shen-sbcl"
    bin.install "bin/sbcl/shen-sbcl"
  end

  test do
    assert_equal "3", shell_output("#{bin}/shen-sbcl -e '(+ 1 2)'")
  end
end
