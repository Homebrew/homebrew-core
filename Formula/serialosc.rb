class Serialosc < Formula
  desc "Opensound control server for monome devices"
  homepage "https://github.com/monome/docs/blob/gh-pages/serialosc/osc.md"
  url "https://github.com/monome/serialosc.git",
      tag:      "v1.4.1",
      revision: "4fec6f11276dd302faf9ca8e0a8e126f273cf954"
  license "ISC"
  head "https://github.com/monome/serialosc.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a67757d6de9663c606ae5baad6c98b1e05270f6ebc7dce5ee856cebd9359523e" => :big_sur
    sha256 "34c28ed9daba6253e5683b1843d4232991be7194b9121684c1e22e45f4f29fa6" => :arm64_big_sur
    sha256 "652e246d1df70f602f497f545c7ef8d69bf7fcbd98fc0af43da944c983f72a32" => :catalina
    sha256 "88d5711e7c26674071d8f5b659c44bc5112edf2b0033b42dc04dba302a418ce5" => :mojave
  end

  depends_on "confuse"
  depends_on "liblo"
  depends_on "libmonome"

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/serialoscd -v")
  end
end
