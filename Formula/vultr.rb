class Vultr < Formula
  desc "Command-line tool for Vultr"
  homepage "https://jamesclonk.github.io/vultr"
  url "https://github.com/JamesClonk/vultr/archive/1.13.0.tar.gz"
  sha256 "9cb5936ba70f958ab4e53a23da0ef7ea5b11de8ebaf194082c3f758779d49650"
  head "https://github.com/JamesClonk/vultr.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "68afe7d76e46923de67f5fe6b7391ff08d0c310937db2e54c04392f19f526dcf" => :high_sierra
    sha256 "05a2602609fd20151e9ab712cd823239e125a5915e5e72f14afa9641a61dc673" => :sierra
    sha256 "0f8ed829f501fad2a7f05e26cfbe7d8b32e3a5df4647021dbe8a9eed16bde438" => :el_capitan
    sha256 "b2bf0d14a74da9e561510fd75694063c8d50ca253b6411940be4ce82a3d2e4ee" => :yosemite
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
