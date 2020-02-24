class Sdedit < Formula
  desc "Tool for generating sequence diagrams very quickly"
  homepage "https://sdedit.sourceforge.io"
  url "https://downloads.sourceforge.net/project/sdedit/sdedit/4.0/sdedit-4.01.jar"
  sha256 "060576f9fe79bda0a65f2cfa0b041fceaf7846f034a7519ef939b73ae82673f1"
  revision 1

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
