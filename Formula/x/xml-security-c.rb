class XmlSecurityC < Formula
  desc "Implementation of primary security standards for XML"
  homepage "https://santuario.apache.org/"
  url "https://shibboleth.net/downloads/xml-security-c/3.0.0/xml-security-c-3.0.0.tar.bz2"
  sha256 "a4c9e1ae3ed3e8dab5d82f4dbdb8414bcbd0199a562ad66cd7c0cd750804ff32"
  license "Apache-2.0"

  livecheck do
    url "https://shibboleth.net/downloads/xml-security-c/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "da245352f56c05ef6603edff2f3ce8cd0831aeac2fe02b38ce11e56523fff2e9"
    sha256 cellar: :any,                 arm64_sequoia: "7f42a4e63dc531c44888737938b0e97780bb25053f42f5cd35671294251a9f6d"
    sha256 cellar: :any,                 arm64_sonoma:  "82490b87ef4a44db821acf34f13bffcf99fd52a3ff372886ee1f001f6d22433a"
    sha256 cellar: :any,                 arm64_ventura: "b4431f1f09c66f1dc9c73eb72cc78c724e0b0a072f93e26917a114b4eae88ccc"
    sha256 cellar: :any,                 sonoma:        "58c0752a0c3a1aa6b51dd7c48058661c0d5c56e7d336412a47db907b851d6451"
    sha256 cellar: :any,                 ventura:       "abc08033a4513a659e7938e3708dabc82fd26451d46ea6f400292e4bef28ff98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "649bcd04da8d6bf105dab88cc9de4c1b6efb55e4b20a75371e7f4a4b96b47761"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cce7dc9da8984c26b39b9e203162782902841d2ca55b40299c846522ba17407"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"
  depends_on "xerces-c"

  # Apply Debian patch to avoid segfault in test
  patch do
    url "https://sources.debian.org/data/main/x/xml-security-c/3.0.0-2/debian/patches/Provide-the-Xerces-URI-Resolver-for-the-tests.patch"
    sha256 "585938480165026990e874fecfae42601dde368f345f1e6ee54b189dbcd01734"
  end

  def install
    system "./configure", "--with-openssl=#{Formula["openssl@3"].opt_prefix}", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "All tests passed", pipe_output("#{bin}/xsec-xtest 2>&1")
  end
end
