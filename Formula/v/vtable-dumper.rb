class VtableDumper < Formula
  desc "List contents of virtual tables in a shared library"
  homepage "https://github.com/lvc/vtable-dumper"
  url "https://github.com/lvc/vtable-dumper/archive/refs/tags/1.2.tar.gz"
  sha256 "6993781b6a00936fc5f76dc0db4c410acb46b6d6e9836ddbe2e3c525c6dd1fd2"
  license "LGPL-2.1-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_linux:  "e6eb8224c4c4acb7c276d913a9e83c650c8c12e574e164846430253b4e53a17f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3b5ec9a7807288402bd3bcffb73137bdbd02c303f2d9aa085d4c93e0f7b45727"
  end

  depends_on "elfutils"
  depends_on :linux

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    libstdcxx = Pathname.glob("/usr/**/libstdc++.so.6").first
    assert_match(/: \d+ entries/, shell_output("#{bin}/vtable-dumper #{libstdcxx}"))
  end
end
