class Spim < Formula
  desc "MIPS32 simulator"
  homepage "https://spimsimulator.sourceforge.net/"
  # No source code tarball exists
  url "https://svn.code.sf.net/p/spimsimulator/code", revision: "764"
  version "9.1.24"
  license "BSD-3-Clause"
  head "https://svn.code.sf.net/p/spimsimulator/code/"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:    "6ce31175ac12463b4fedd31724fe17aeef8119826168717c3aaf57fa049ace15"
    sha256 arm64_sequoia:  "0bbfdf9f722ade3b41dba3007110f92b87f5cdae144349b030399253fc7cf29c"
    sha256 arm64_sonoma:   "a6a8458888bdc561d8f80f70c1010496864b7c9a1bdda22b784aff1a68c6e9a6"
    sha256 arm64_ventura:  "815ba1c52cb4d6f1f216b10ed22f2c6e44802a774a5c3f8c0f5929deee570c31"
    sha256 arm64_monterey: "b3d11635140aed3325a3de85e70524b8016ee2a0851d1d1d5c319596b14c9d64"
    sha256 sonoma:         "df97a10541f2bb5940ae426aaeaac7e973a5ce5c02f00f57cc9ac057f5853f27"
    sha256 ventura:        "a362f8d46914498632a89be198c999311152adcc5a785529f1e73b666a681100"
    sha256 monterey:       "b58327df67b8e42369981b471a6e2e1e0be51546bcd9ad30469bc1e88f862f57"
    sha256 arm64_linux:    "c4ad7c44cf7df0e7624ff25309bf64cd966d352db59cbdeb8598c6a7ea1caf37"
    sha256 x86_64_linux:   "3152719ea751f8e21e5febb3053cc7e8d9c171644b519ebd61e18a753b00225c"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
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
