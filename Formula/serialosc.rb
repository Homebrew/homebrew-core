class Serialosc < Formula
  desc "Opensound control server for monome devices"
  homepage "http://monome.org/docs/osc/"
  url "https://github.com/monome/serialosc.git",
    :tag => "v1.4",
    :revision => "c46a0fa5ded4ed9dff57a47d77ecb54281e2e2ea"
  head "https://github.com/monome/serialosc.git"

  bottle do
    cellar :any
    sha256 "b2b9ec1d9e3058d7752eed3773f7fa724981ddbae5a990db10ad3e98f02d1c1f" => :el_capitan
    sha256 "a601c8dcadb93c4e4ee0f15e7db22dc0e124bcaf9a3e7b875091d612ea70b078" => :yosemite
    sha256 "e08f42f4285870af8ba9f341cda5e4420c7535a55f54c9fb78582cfd53fdad3a" => :mavericks
  end

  depends_on "liblo"
  depends_on "confuse"
  depends_on "libmonome"

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/serialosc-device -v")
  end
end
