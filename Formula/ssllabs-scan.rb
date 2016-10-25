class SsllabsScan < Formula
  desc "This tool is a command-line client for the SSL Labs APIs."
  homepage "https://github.com/ssllabs/ssllabs-scan/"
  url "https://github.com/ssllabs/ssllabs-scan/archive/v1.4.0.tar.gz"
  sha256 "a7d5fad92649172ca4b190f481172b602aa1ae103d14dd1f1951ee250d382eec"

  bottle do
    cellar :any_skip_relocation
    sha256 "5c8161ee0aea2d6e7a2594c5bdd75f7495cabdf837fe74400f53505f3228c522" => :sierra
    sha256 "c6d802dc3315188634b5f59053875ce37f777083d80503959daeff6c4cc118ad" => :el_capitan
    sha256 "d3dbcf383703972c8acf0a2f2a5264434a7e67777996afd8a3e73875a743b492" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "make", "build"
    bin.install "ssllabs-scan"
  end

  def caveats; <<-EOS.undent
    By installing this package you agree to the Terms and Conditions defined by Qualys.
    You can find the terms and conditions at this link:
       https://www.ssllabs.com/about/terms.html

    If you do not agree with those you should uninstall the formula.
  EOS
  end

  test do
    system "#{bin}/ssllabs-scan", "-grade", "-quiet", "-usecache", "ssllabs.com"
  end
end
