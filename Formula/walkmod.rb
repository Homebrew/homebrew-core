class Walkmod < Formula
  desc "Java-based open source tool to apply and share code conventions"
  homepage "http://www.walkmod.com"
  url "https://bitbucket.org/rpau/walkmod/downloads/walkmod-3.0.0-installer.zip"
  sha256 "72c8ac53637735ff6380c42b90302ee4151982d02173a2453f4f2b5c14cbf80c"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]
    libexec.install Dir["*"]
    bin.install_symlink libexec+"bin/walkmod"
  end

  test do
    system "git", "clone", "--depth", "1", "https://github.com/walkmod/walkmod-core.git"
    cd "walkmod-core"
    system bin/"walkmod", "chains"
  end
end
