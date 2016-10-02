class Rolldice < Formula
  desc "Rolls an amount of virtual dice"
  homepage "https://github.com/sstrickl/rolldice"
  url "https://github.com/sstrickl/rolldice/archive/v1.16.tar.gz"
  sha256 "8bc82b26c418453ef0fe79b43a094641e7a76dae406032423a2f0fb270930775"

  bottle do
    cellar :any_skip_relocation
    sha256 "590b82ca6bb16b5acd3bff29985138c9d3383eb274f27615d5843e176b08464b" => :sierra
    sha256 "b15c8dd417d710a734f2b445083752dd072b6d1cb39260901dcbd9634820fe8d" => :el_capitan
    sha256 "4e818eaba72271765a7c50c97a60764c37e0a1c6d4308e4490dbe811b32ff8ba" => :yosemite
    sha256 "4974aa7720ba08112cfd0eecc2611a82eb8fc9ac379fe779ba98f5e1509255e6" => :mavericks
  end

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install "rolldice"
    man6.install gzip("rolldice.6")
  end

  test do
    assert_match "Roll #1", shell_output("#{bin}/rolldice -s 1x2d6")
  end
end
