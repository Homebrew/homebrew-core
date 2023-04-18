class Spim < Formula
  desc "MIPS32 simulator"
  homepage "https://spimsimulator.sourceforge.io/"
  # No source code tarball exists
  url "https://svn.code.sf.net/p/spimsimulator/code", revision: "749"
  version "9.1.23"
  license "BSD-3-Clause"
  head "https://svn.code.sf.net/p/spimsimulator/code/"

  bottle do
    sha256                               arm64_ventura:  "884c825255b5915044db2bb49779018a5439749355b0d42ced7afbf50470b5a5"
    sha256                               arm64_monterey: "bdc5c60be138784fc2abc92e1f75db7024c81867a53f6f9eeedfbb092f4c6534"
    sha256                               arm64_big_sur:  "75f374887912346bd6acf5639a0f1b506c99feea75f0d4647ed233310be2f060"
    sha256                               ventura:        "ef5643eabf9261c32c62cf0c305d2ddb4d5aae0cc5602b5c2f6146185daa3391"
    sha256 cellar: :any_skip_relocation, monterey:       "1d5234fbb252011107f344fdbc7f249591ae3f3fe851e1e28a8b531ec37d46c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1d1629354ab4e842c9254e47b420f56974c0611c24d267ba048fa5bf6055079"
    sha256 cellar: :any_skip_relocation, catalina:       "c6f9828c0a790cf3aa2f9bc0b2a7c6ce5f2ea730a942508921950bc6da601cae"
    sha256                               x86_64_linux:   "1b6edb0c5f5adaf513d6c5a1688852ee32f7091331db280ecc3a74d048a05c76"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    bin.mkpath
    cd "spim" do
      system "make", "EXCEPTION_DIR=#{share}"
      system "make", "install", "BIN_DIR=#{bin}",
                                "EXCEPTION_DIR=#{share}",
                                "MAN_DIR=#{man1}"
    end
  end

  test do
    assert_match "__start", pipe_output("#{bin}/spim", "print_symbols")
  end
end
