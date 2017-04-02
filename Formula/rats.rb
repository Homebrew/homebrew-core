class Rats < Formula
  desc "Rough auditing tool for security"
  homepage "https://security.web.cern.ch/security/recommendations/en/codetools/rats.shtml"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/rough-auditing-tool-for-security/rats-2.4.tgz"
  sha256 "2163ad111070542d941c23b98d3da231f13cf065f50f2e4ca40673996570776a"

  bottle do
    sha256 "5f2a74a60c30a825ad036f390e3830346be4fe3299a28a81e25630d54defd119" => :sierra
    sha256 "224ae02df998c8fc296bf3905fbc369a787fc55f5ef295d63f1b3c44bfee7a5d" => :el_capitan
    sha256 "7c26f10919e103d7e57c232e0e07840ad309fd04878831c04829d70506767157" => :yosemite
    sha256 "ab9d3469ecf24da07c80691cea41aa0266e85061ad3ddfec6cf65a0bd7c85acf" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}"
    system "make", "install"
  end

  test do
    system "#{bin}/rats"
  end
end
