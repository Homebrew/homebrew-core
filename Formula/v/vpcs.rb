class Vpcs < Formula
  desc "Virtual PC simulator for testing IP routing"
  homepage "https://vpcs.sourceforge.net/"
  url "https://github.com/GNS3/vpcs/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "1d5443366db189d50331d2b83a23bdb172568b3b77bb0890d9cc8307e58d0023"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b119202d1c5c35a7af45713e6f4daeb4f63050d032fbb19065f2801defe64351"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "328d5ad0176e1eb5e709f3ddc330afde3f80fc7643bb90957e8c1009f695507a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "52976360dd75517c622ee05444b8a6aac2fc6b6d70188a9b3652aa8f9ee7574f"
    sha256 cellar: :any,                 arm64_linux:       "ca137413ac618185cae30b4d4b356dc6c53900dbe8577aacbbc0aaa2378cf747"
    sha256 cellar: :any,                 x86_64_linux:      "ebc21324e28853068b091234f119e29fd7aa011ee6cd4b555cbae84fc62b27c7"
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
