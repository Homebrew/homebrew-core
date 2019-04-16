class Zilf < Formula
  desc "Tools for working with the Zork Implementation Language from Infocom"
  homepage "https://bitbucket.org/jmcgrew/zilf/"
  url "https://bitbucket.org/jmcgrew/zilf/downloads/zilf-0.8.zip"
  sha256 "60b38260e868910095a6351e5c635ebf58e12dbd66de9677665664ccbd603286"

  bottle :unneeded

  depends_on "mono"

  def install
    prefix.install "README.txt"
    bin.install Dir["bin/*.dll", "bin/*.exe"]
    prefix.install Dir["doc", "library", "sample"]
    (bin/"zilf").write <<~EOS
      #!/bin/sh
      mono #{bin}/zilf.exe "$@"
    EOS
    (bin/"zapf").write <<~EOS
      #!/bin/sh
      mono #{bin}/zapf.exe "$@"
    EOS
  end

  test do
    system "#{bin}/zilf", "-x", "#{prefix}/sample/cloak.zil"
  end
end
