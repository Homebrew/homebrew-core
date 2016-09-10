class Voms < Formula
  desc "Virtual organization membership service"
  homepage "https://github.com/italiangrid/voms"
  url "https://github.com/italiangrid/voms-clients/archive/v3.0.7.tar.gz"
  sha256 "24cc29f4dc93f048e1cda9003ab8004e5d0ebc245d0139a058e6224bc2ca6ba7"

  bottle do
    cellar :any_skip_relocation
    sha256 "e2a6c2ebe242fccfc3935156373a0086adf7f001cb78a219e60f676963d6d3d6" => :el_capitan
    sha256 "b3fc4b76fd0e255a6da44e535e970b9c03f4380e50096d94fcb6492cc545d33a" => :yosemite
    sha256 "ada0fac58d31d9e8d794c5236cc42816722e358f1b5c4c26931a641a885e8fdd" => :mavericks
  end

  depends_on :java
  depends_on "maven" => :build
  depends_on "openssl"

  def install
    system "mvn", "package", "-Dmaven.repo.local=$(pwd)/m2repo/", "-Dmaven.javadoc.skip=true"
    system "tar", "-xf", "target/voms-clients.tar.gz"
    share.install "voms-clients/share/java"
    man5.install Dir["voms-clients/share/man/man5/*.5"]
    man1.install Dir["voms-clients/share/man/man1/*.1"]
    bin.install Dir["voms-clients/bin/*"]
  end

  test do
    system "#{bin}/voms-proxy-info", "--version"
  end
end
