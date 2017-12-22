class Vultr < Formula
  desc "Command-line tool for Vultr"
  homepage "https://jamesclonk.github.io/vultr"
  url "https://github.com/JamesClonk/vultr/archive/1.13.0.tar.gz"
  sha256 "9cb5936ba70f958ab4e53a23da0ef7ea5b11de8ebaf194082c3f758779d49650"
  head "https://github.com/JamesClonk/vultr.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "afc91aa3d98447dcdc93892d94dc2b00ed5d4af0b6f1095a80ae4641f0abb23b" => :high_sierra
    sha256 "87683a1ade9779c8431f08a76a3801890a437a499144646c5232db0567ea4712" => :sierra
    sha256 "7ca573144e22487f7c506073cda826ba46e768ab0f34230b1f2375799580c39b" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/JamesClonk").mkpath
    ln_s buildpath, buildpath/"src/github.com/JamesClonk/vultr"
    system "go", "build", "-o", bin/"vultr"
  end

  test do
    system bin/"vultr", "version"
  end
end
