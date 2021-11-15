class Rats < Formula
  desc "Rough auditing tool for security"
  homepage "https://security.web.cern.ch/security/recommendations/en/codetools/rats.shtml"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/rough-auditing-tool-for-security/rats-2.4.tgz"
  sha256 "2163ad111070542d941c23b98d3da231f13cf065f50f2e4ca40673996570776a"
  license "GPL-2.0"

  bottle do
    sha256 arm64_monterey: "a210be283710fa3c506e9fae4dd915bcd737904272df4c985c5f54d666b3a745"
    sha256 arm64_big_sur:  "bfe1ae23fc4335ffdc160f80613e519c810b259b48ddef7de9d0d227625a3407"
    sha256 monterey:       "5798bdf316715050aee914343db4155c7ef89fa274908b85def50a84729c0845"
    sha256 big_sur:        "d71b401eb933729bd6d4b8f6cfdae7bbeb7f81de55b91f8d0aadcbb619c1fcce"
    sha256 catalina:       "bf5da3e9088abba09350b4a812691a3f76b00bfce1c74947fb7c016d88eb89f9"
    sha256 mojave:         "77244d885c0f203d64bd4054105310a797a9b44333bf4ef1f7b7cec63b0a163f"
    sha256 high_sierra:    "6ae19bc72cfea62b56b83931f95a70f27ce9a13617026292861a272e22269135"
    sha256 sierra:         "5f2a74a60c30a825ad036f390e3830346be4fe3299a28a81e25630d54defd119"
    sha256 el_capitan:     "224ae02df998c8fc296bf3905fbc369a787fc55f5ef295d63f1b3c44bfee7a5d"
    sha256 yosemite:       "7c26f10919e103d7e57c232e0e07840ad309fd04878831c04829d70506767157"
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
