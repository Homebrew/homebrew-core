class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "https://gitlab.com/esr/reposurgeon/-/archive/4.34/reposurgeon-4.34.tar.gz"
  sha256 "85bf287001fd030a343b6113e46e54ba9e5e90b734013373e3b53a50efec7255"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/reposurgeon.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c2ee4b1e506992a52cd2f906e6533cd4dd9b5c8c38692f75101779e870d3b9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d2b3ea48e7faf96f9bcf08a3d0cc8760e3b5a6ed63995482f82bae9f29df7ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d825b97e4c3a253a49f62ffb3c08b3e8d6a471ecd180f7f1048732da26a1f3bd"
    sha256 cellar: :any_skip_relocation, ventura:        "624473a08bc14b16050edb1596d00d64158049e20192afcb236c07ef593c6bd2"
    sha256 cellar: :any_skip_relocation, monterey:       "79f989ef74acbd5000ca95948df3a0cf911053e9fa011d5eb61ea7bb95d4e84f"
    sha256 cellar: :any_skip_relocation, big_sur:        "533416ab9826b6fe24b60b629997b46b09e65e1d6b3ce70ac05fa6517199f45f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e8bf8f1bbcf6bdf88bfb1cd1103619c5ec1f731dbccc06bc30d87950e3f0627"
  end

  depends_on "asciidoctor" => :build
  depends_on "go" => :build
  depends_on "git" # requires >= 2.19.2

  uses_from_macos "ruby"

  on_system :linux, macos: :catalina_or_older do
    depends_on "gawk" => :build
  end

  def install
    ENV.append_path "GEM_PATH", Formula["asciidoctor"].opt_libexec
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "make"
    system "make", "install", "prefix=#{prefix}"
    elisp.install "reposurgeon-mode.el"
  end

  test do
    (testpath/".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS
    system "git", "init"
    system "git", "commit", "--allow-empty", "--message", "brewing"

    assert_match "brewing",
      shell_output("#{bin}/reposurgeon read list")
  end
end
