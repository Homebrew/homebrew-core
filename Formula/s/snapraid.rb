class Snapraid < Formula
  desc "Backup program for disk arrays"
  homepage "https://www.snapraid.it/"
  url "https://github.com/amadvance/snapraid/releases/download/v14.6/snapraid-14.6.tar.gz"
  sha256 "056f86b4f69265692d15d742ea7427804ef2e873aec4263425abb138be86fb08"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "caa22c99ade5e33bcf81b0c196124e08379fb7c792b40abcc994aa1a0c3e1d66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df2416eee79b7313186a3b2b4a3899e06ba45dc546b71f3348e013bca2a13b12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21fe9743ccdfd934f165b4a6f426488493b154af17783fecfab6e7fef043d63a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b30c0bc557ef018e3cdae53285d34642e3104a990cefd5dd307395bfa125ed6"
    sha256 cellar: :any,                 arm64_linux:   "78d49db4604eff4ffc07613352f99db42b28fa89d6f501d28ca67d71241dbacf"
    sha256 cellar: :any,                 x86_64_linux:  "88f51df415343dee622345b74a3643d0782832b01fe7b031f3d81f6309dcb0f5"
  end

  head do
    url "https://github.com/amadvance/snapraid.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snapraid --version")
  end
end
