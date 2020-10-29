class Xmlsh < Formula
  desc "XML shell"
  homepage "http://www.xmlsh.org"
  url "http://xmlsh-org-downloads.s3-website-us-east-1.amazonaws.com/archives%2Frelease-1_3_1%2Fxmlsh_1_3_1.zip"
  sha256 "b52daadac61920a8a5b241795f1348298327db9841c052114f2351b365a23e2f"

  livecheck do
    url :stable
    regex(%r{url=.*?/v?(\d+(?:\.\d+)+)/xmlsh}i)
  end

  bottle :unneeded

  def install
    rm_rf %w[win32 cygwin]
    libexec.install Dir["*"]
    chmod 0755, "#{libexec}/unix/xmlsh"
    (bin/"xmlsh").write <<~EOS
      #!/bin/bash
      export XMLSH=#{libexec}
      exec #{libexec}/unix/xmlsh "$@"
    EOS
  end

  test do
    output = shell_output("#{bin}/xmlsh -c 'x=<[<foo bar=\"baz\" />]> && echo <[$x/@bar]>'")
    assert_equal "baz\n", output
  end
end
