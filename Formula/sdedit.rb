class Sdedit < Formula
  desc "Tool for generating sequence diagrams very quickly"
  homepage "https://sdedit.sourceforge.io"
  url "https://downloads.sourceforge.net/project/sdedit/sdedit/4.2/sdedit-4.2.1.jar"
  sha256 "270af857e6d2823ce0c18dee47e1e78ef7bc90c7e8afeda36114d364e0f4441c"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/sdedit[._-]v?(\d+(?:\.\d+)+)\.jar}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "cf1ff79f7e7bd0648236f1a1aca45fe7204501dd69bb0ef30f1f8104569130f7"
  end

  depends_on "openjdk"

  def install
    libexec.install "sdedit-#{version}.jar"
    bin.write_jar_script libexec/"sdedit-#{version}.jar", "sdedit"
  end

  test do
    (testpath/"test.sd").write <<~EOS
      #![SD ticket order]
      ext:External[pe]
      user:Actor
    EOS
    system bin/"sdedit", "-t", "pdf", "-o", testpath/"test.pdf", testpath/"test.sd"
    assert_predicate testpath/"test.pdf", :exist?
  end
end
