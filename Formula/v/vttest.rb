class Vttest < Formula
  desc "Test compatibility of VT100-compatible terminals"
  homepage "https://invisible-island.net/vttest/"
  url "https://invisible-mirror.net/archives/vttest/vttest-20251205.tgz"
  sha256 "cd6886f9aefe6a3f6c566fa61271a55710901a71849c630bf5376aa984bf77cc"
  license "BSD-3-Clause"

  livecheck do
    url "https://invisible-mirror.net/archives/vttest/"
    regex(/href=.*?vttest[._-]v?(\d+(?:[.-]\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2205eb531e5a84cafac03fddba51d325d33e289e12a93443dfd2325049946e76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab95bdec102ef89bafa116cfa8277f6b3272af4118f95600cc4485c76e4243ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4bf9cb4901a675292b269021a9a77967dd5a9faf5ddea6d86e69de8ebe1a080"
    sha256 cellar: :any_skip_relocation, sonoma:        "c99f02549908d444b2b127da4c7d243906af3c839c12d780f459502731dcb1a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a278f00ace7fe21bcb7a23cc775b0212b6b73bf0dc6e70a544a944fb76f53fc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9608f0fae9a0f0d1abb464b8064ebb23c68223eae73adf82ec0d5e2f20d26c3b"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vttest -V")
  end
end
