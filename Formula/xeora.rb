class Xeora < Formula
  desc "Web Development Framework Command-line Interface"
  homepage "http://www.xeora.org"
  url "http://www.xeora.org/Tools/CLI/xeora-cli_v1.0.17506_macos.tgz"
  version "1.0.17506"
  sha256 "9da57f2b699a66d15c93a269651fbcbb7e0a6f3c008dec815c87c8658c1649c1"

  def install
    libexec.install Dir["*.pdb", "*.json", "*.dll"]
    bin.install "xeora"
    File.rename bin/"xeora", bin/"xeora-cli"
    (bin/"xeora").write_env_script(bin/"xeora-cli", :XEORAPATH => libexec)
  end

  test do
    assert shell_output("#{bin}/xeora -v", 1)
  end
end
