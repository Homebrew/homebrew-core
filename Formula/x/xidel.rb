class Xidel < Formula
  desc "XPath/XQuery 3.0, JSONiq interpreter to extract data from HTML/XML/JSON"
  homepage "https://www.videlibri.de/xidel.html"
  url "https://github.com/benibela/xidel/releases/download/Xidel_0.9.8/xidel-0.9.8.src.tar.gz"
  sha256 "72b5b1a2fc44a0a61831e268c45bc6a6c28e3533b5445151bfbdeaf1562af39c"
  license "GPL-3.0-or-later"
  revision 2

  livecheck do
    url :stable
    regex(/^(?:Xidel[-_])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "893ce6750b83aacf15da84dc44f535f5c5d748bbf34042a89338d0648eeabf0a"
    sha256 cellar: :any,                 arm64_sequoia: "d4c138e8f96841a078760a66d77c550851edb5b53821581b525fbbd422c07e74"
    sha256 cellar: :any,                 arm64_sonoma:  "4216a3bfbff62a9c4be411d277a01eefd54c1b0654d253830dcce54a116c5392"
    sha256 cellar: :any,                 sonoma:        "aee924c40e2005e7144f90b9d3c1ef77c85dc992af3f53b110d47a01fc3715fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "788625993895701af031f238eee640ba17e88aa2e4db6336c05c265852c16375"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "269d8d4872005910434489a6f980e3b6ec646863ff5d763108ec664acbb52b30"
  end

  head do
    url "https://github.com/benibela/xidel.git", branch: "master"
    resource("flre") { url "https://github.com/benibela/flre.git", branch: "master" }
    resource("internettools") { url "https://github.com/benibela/internettools.git", branch: "master" }
    resource("pasdblstrutils") { url "https://github.com/BeRo1985/pasdblstrutils.git", branch: "master" }
    resource("rcmdline") { url "https://github.com/benibela/rcmdline.git", branch: "master" }
    resource("synapse") { url "https://svn.code.sf.net/p/synalist/code/synapse/40/" }
  end

  depends_on "fpc" => :build
  depends_on "openssl@4"

  def install
    resources.each do |r|
      r.stage buildpath/"import"/r.name
    end

    cd "programs/internet/xidel" if build.stable?
    inreplace "build.sh", "$fpc ", "$fpc -k-rpath -k#{sh_quote Formula["openssl@4"].opt_lib.to_s} "
    system "./build.sh"
    bin.install "xidel"
    man1.install "meta/xidel.1"
  end

  test do
    assert_equal "123\n", shell_output("#{bin}/xidel -e 123")
  end
end
