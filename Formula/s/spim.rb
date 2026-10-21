class Spim < Formula
  desc "MIPS32 simulator"
  homepage "https://spimsimulator.sourceforge.net/"
  license "BSD-3-Clause"
  head "https://svn.code.sf.net/p/spimsimulator/code/"

  stable do
    url "https://src.fedoraproject.org/repo/pkgs/spim/spimsimulator-spim-20230804.tar.gz/sha512/628801e566c73ad4e0ebce04dedb97b1d55618cd7709cac6a1742c46523ce6be9e820c2e3afc87207ee9bc0304880ac2e15563630cde1d43c0dfb1022b6767b9/spimsimulator-spim-20230804.tar.gz"
    version "9.1.24"
    sha256 "f163fc3e9d58ea9d63d24c0df2b0ff374354d5ecfeda8d8aefab8e6e6ffa9924"

    resource "CPU" do
      url "https://src.fedoraproject.org/repo/pkgs/spim/spimsimulator-CPU-20230804.tar.gz/sha512/d5732125ffdefbb75d6795a5358cda18c3f22114af80ce4e34c43ea2f9556ede6220b5032454fab6fd334521eddecd3928706cc0ee1835a39035aeceacdd9684/spimsimulator-CPU-20230804.tar.gz"
      sha256 "0368c73db63d1dcfa2db79e8f620d38500c0080f539e491dfa6494354357f9d7"
    end

    resource "Documentation" do
      url "https://src.fedoraproject.org/repo/pkgs/spim/spimsimulator-Documentation-20230804.tar.gz/sha512/f8fe10b07265ed71582c30205e352d345fd2f80a4d98206910f470a3255740623d594119a450bde9a75784e0dc0d6f3fc12170d71b8df7991c54b2bb932e5f6d/spimsimulator-Documentation-20230804.tar.gz"
      sha256 "baad6b5fc94b9c6ef957cd08e510735b1e0c174e329ea966cff776991227737c"
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    rebuild 2
    sha256 arm64_golden_gate: "bfa493c9c80e365fe5721ab6226f244528ab8cebfe6dca8899579d1ca8eedf1d"
    sha256 arm64_tahoe:       "fecdc6101845049336385f58800dc0c996698568336e6d3165f3c673f18f8f7c"
    sha256 arm64_sequoia:     "0ee17f876d15fd6b88452e7d19f2c1a182ce248aef26c1182deee6ba30538d45"
    sha256 arm64_linux:       "db5606732a7bb6086e650d673c3b4c22366a4a4cf6cd777a0681f16b18bd5793"
    sha256 x86_64_linux:      "c1b178dd6ac7d8be0bb3fc1c5cde0fa5da7ae94159ff69013a050fd0051676ba"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    (buildpath/"spim").install Dir["*"] if build.stable?
    resources.each { |r| r.stage buildpath/r.name }

    bin.mkpath
    cd "spim" do
      system "make", "EXCEPTION_DIR=#{share}"
      system "make", "install", "BIN_DIR=#{bin}",
                                "EXCEPTION_DIR=#{share}"
      system "make", "install-man", "MAN_DIR=#{man1}"
    end
  end

  test do
    assert_match "__start", pipe_output(bin/"spim", "print_symbols")
  end
end
