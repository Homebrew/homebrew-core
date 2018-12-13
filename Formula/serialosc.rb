class Serialosc < Formula
  desc "Opensound control server for monome devices"
  homepage "https://monome.org/docs/osc/"
  url "https://github.com/monome/serialosc.git",
      :tag      => "v1.4.1",
      :revision => "4fec6f11276dd302faf9ca8e0a8e126f273cf954"
  head "https://github.com/monome/serialosc.git"

  bottle do
    cellar :any
    sha256 "e0bf57d0c476bba84d0fd54ef092ebcc0077a163f9313a659ea3401502de43ad" => :high_sierra
    sha256 "708a6230d77c734f5bb5c7f6f09d76cc02f345aa9ff82b392ed48e76236c06e1" => :sierra
    sha256 "538a58e048362ab6561a3ba60a4bce9a262ec6245c2bdbf2c3b07a21c8f725cc" => :el_capitan
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
