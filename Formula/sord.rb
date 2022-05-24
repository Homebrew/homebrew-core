class Sord < Formula
  desc "C library for storing RDF data in memory"
  homepage "https://drobilla.net/software/sord.html"
  url "https://download.drobilla.net/sord-0.16.8.tar.bz2"
  sha256 "7c289d2eaabf82fa6ac219107ce632d704672dcfb966e1a7ff0bbc4ce93f5e14"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net"
    regex(/href=.*?sord[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "65060c80a5f82092e950d54d4e0c161c276ab4011511c67b8045675c4a92e872"
    sha256 cellar: :any,                 arm64_big_sur:  "ec9d443ac5fc598d0718dd33a9c19fc8f2d2f38975512ce79acabd2d5e509fd7"
    sha256 cellar: :any,                 monterey:       "eb739359d67f246df683e696269444efda918395d3755f5b078b3a4727c5865b"
    sha256 cellar: :any,                 big_sur:        "30fed8a7b4747de9ed632640e1b2aa326e0c5bb71030d0924b934d820fe87ef5"
    sha256 cellar: :any,                 catalina:       "e0ca8e8fd6e2ba8ccec9cb75c8bb2f1d1fe09ba8ebce886f78eed4c87343ab93"
    sha256 cellar: :any,                 mojave:         "2d69dca2635bf0808ce19d65e6a795d1591b5f197b2cc703fa9fa084d81d6c2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16c2362dcac47cf4f10c118678422f327c9d09d90574718c93000bd30b526ef1"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "pcre"
  depends_on "serd"

  def install
    system "python3", "./waf", "configure", "--prefix=#{prefix}"
    system "python3", "./waf"
    system "python3", "./waf", "install"
  end

  test do
    path = testpath/"input.ttl"
    path.write <<~EOS
      @prefix : <http://example.org/base#> .
      :a :b :c .
    EOS

    output = "<http://example.org/base#a> <http://example.org/base#b> <http://example.org/base#c> .\n"
    assert_equal output, shell_output(bin/"sordi input.ttl")
  end
end
