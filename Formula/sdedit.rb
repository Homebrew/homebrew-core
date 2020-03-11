class Sdedit < Formula
  desc "Tool for generating sequence diagrams very quickly"
  homepage "https://sdedit.sourceforge.io"
  url "https://downloads.sourceforge.net/project/sdedit/sdedit/4.2/sdedit-4.2.1.jar"
  sha256 "270af857e6d2823ce0c18dee47e1e78ef7bc90c7e8afeda36114d364e0f4441c"

  bottle :unneeded

  depends_on "openjdk"

  def install
    libexec.install "sdedit-#{version}.jar"
    (bin/"sdedit").write <<~EOS
      #!/bin/bash
      exec "#{Formula["openjdk"].opt_bin}/java" -jar "#{libexec}/sdedit-#{version}.jar" "$@"
    EOS
  end

  test do
    (testpath/"test.sd").write <<~EOS
      #![SD ticket order]
      ext:External[pe]
      user:Actor
    EOS
    system bin/"sdedit", "-t", "pdf", "-o", testpath/"test.pdf", testpath/"test.sd"
  end
end
