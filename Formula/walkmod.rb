class Walkmod < Formula
  desc "Java-based open source tool to apply and share code conventions"
  homepage "http://www.walkmod.com"
  url "https://bitbucket.org/rpau/walkmod/downloads/walkmod-3.0.0-installer.zip"
  sha256 "22eea09a5246d3f8e15e7b56189db32fc11f19ca5f72f628c2b29bbe7764308e"

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
    system bin/"walkmod", "check", "-e"
  end
end
