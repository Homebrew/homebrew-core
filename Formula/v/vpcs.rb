class Vpcs < Formula
  desc "Virtual PC simulator for testing IP routing"
  homepage "https://vpcs.sourceforge.net/"
  url "https://github.com/GNS3/vpcs/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "2b816f8943cddc83f450812d3969da22e97314208221a23df9658887aea5a587"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26eb3efc1f583dcf455b593966bf334fa7d2311ac72e1e6511d6ceea4a196772"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8af6d317ac16318a07c1e64ea5aaaf7634207a5d6f2a784da4194b79c48a0a9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f5f649b4fdb3e2f688a108d907701db39d5ab779c2024a1e1d5ba4ae7ad7561"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e990b9acd8e86b7a2ca5e0a9a66904db6351b31ecec847f2a0ed37e32137b60"
    sha256 cellar: :any,                 arm64_linux:   "590cd07464845587549fc079fcfd88c0aa12d670fea2dd4435b83a837cb6f142"
    sha256 cellar: :any,                 x86_64_linux:  "c8bb368e1a345412369519f736646f7f65e7f7939ad3601c945dd8ab60335343"
  end

  def install
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    system "make", "-C", "src", "-f", "Makefile.#{os}"
    bin.install "src/vpcs"
  end

  test do
    system bin/"vpcs", "--version"
  end
end
