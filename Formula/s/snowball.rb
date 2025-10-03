class Snowball < Formula
  desc "Stemming algorithms"
  homepage "https://snowballstem.org"
  url "https://github.com/snowballstem/snowball/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "80ac10ce40dc4fcfbfed8d085c457b5613da0e86a73611a3d5527d044a142d60"
  license "BSD-3-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab44ad284224fc7948a61026b26c2909ca0c95132c0476a82d86b3d7d0a64ab2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00c79db6c8ba404a5ad086c5e50a7102d0df266ee3fb3b5deafe4ed8e7184c71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d7f77bad2cee9519cbe39492c5234455b01f1de41381279e8d63d6762f4c2f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42cd2f37f93d279ad348fb7933739db82bdbb2602d1f7e1f40b6b0113dd4dc3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "58eadab9b1887a26cb95506a264f0e53bf9a23d9d1cf6fe589533c8f20daa7c2"
    sha256 cellar: :any_skip_relocation, ventura:       "cd975136128f07351d331ec0c05bcc7bae659059e9f7a42c1c19d3d03d88a751"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a90617188624e914be73ec75078cebac9e2ee7458f0006225dba41da4fd2e431"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b8fd0e7fee01a520f36dfd8631171bb7fcfab8ddccb8ed9c37b069f338b6ca9"
  end

  def install
    system "make"

    lib.install "libstemmer.a"
    include.install Dir["include/*"]
    pkgshare.install "examples"
  end

  test do
    (testpath/"test.txt").write("connection")
    cp pkgshare/"examples/stemwords.c", testpath
    system ENV.cc, "stemwords.c", "-L#{lib}", "-lstemmer", "-o", "test"
    assert_equal "connect\n", shell_output("./test -i test.txt")
  end
end
