class Sdedit < Formula
  desc "Tool for generating sequence diagrams very quickly"
  homepage "https://sdedit.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/sdedit/sdedit/4.2/sdedit-4.2.1.jar"
  sha256 "270af857e6d2823ce0c18dee47e1e78ef7bc90c7e8afeda36114d364e0f4441c"
  license "BSD-2-Clause"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/sdedit[._-]v?(\d+(?:\.\d+)+)\.jar}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "b53e1a2647aa46c3b1955e0aa26329c42d4bb5defd34d3dab8d4a6b2897bdaeb"
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
    assert_path_exists testpath/"test.pdf"
  end
end
