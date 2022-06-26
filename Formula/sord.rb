class Sord < Formula
  desc "C library for storing RDF data in memory"
  homepage "https://drobilla.net/software/sord.html"
  url "https://download.drobilla.net/sord-0.16.10.tar.bz2"
  sha256 "9c70b3fbbb0c5c7bf761ef66c3d5b939ab45ad063e055990f17f40f1f6f96572"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net"
    regex(/href=.*?sord[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9d402a07136ecdd2d2d4005cc27dd0fa7cfd7f06ff05077f95f99fe59d66b029"
    sha256 cellar: :any,                 arm64_big_sur:  "467ef187ee0bb533d4082b3c99411d0c64a407ae535555def70a830d0f1ce14d"
    sha256 cellar: :any,                 monterey:       "5fd6561f1fb6f551323b7ead34c3c93485076455df64ce5051f5aa536a31cd68"
    sha256 cellar: :any,                 big_sur:        "74c80fd80a8c3cf5672c31e8c1967cae4f4f48093a9551de08d3f542565b1eff"
    sha256 cellar: :any,                 catalina:       "82c6d6362b7ed299f0e5639243e92e6ef118072214b6b4077ac94c7e520f4aa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c469e65f11e0450f094a593428d865a70398a28085eaf7aaae8dd02b9efc6a5"
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
