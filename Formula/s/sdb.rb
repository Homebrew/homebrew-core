class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://www.radare.org/"
  url "https://github.com/radareorg/sdb/archive/refs/tags/2.4.4.tar.gz"
  sha256 "48ed1f40a4a1903646c24fa17b8e2be13ac64c2a441758d5f301043820fab1b8"
  license "MIT"
  head "https://github.com/radareorg/sdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9ac5cc39aa93c9f87e59fa7711238049e070e993043e9515ecaf21d1824b2542"
    sha256 cellar: :any,                 arm64_sequoia: "68e56bc60c4e046b57b802607f51d0fec19c2e908766be5b5819fb2d3d5faf02"
    sha256 cellar: :any,                 arm64_sonoma:  "85a7766ab4196a62875694ba53775e04bc9507ed4cbbc6c0c0fe01f8a6e4d8eb"
    sha256 cellar: :any,                 sonoma:        "f212c7fef7edb1bafc58516797ac92a02fc2b37962ee01b15d20605023876aa7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "624954e2711694f727e67a2900d7ef1d0295fd802d1c8d4279678cc92925fbf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4854ed5f2a975879b9cffee64d82eda8a821cea53c0b15e043ed54950f26566"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "vala" => :build
  depends_on "glib"

  conflicts_with "snobol4", because: "both install `sdb` binaries"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"sdb", testpath/"d", "hello=world"
    assert_equal "world", shell_output("#{bin}/sdb #{testpath}/d hello").strip
  end
end
