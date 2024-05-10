class Quotatool < Formula
  desc "Edit disk quotas from the command-line"
  homepage "https://quotatool.ekenberg.se/"
  url "https://github.com/ekenberg/quotatool.git",
    tag:      "v1.6.4",
    revision: "f7a4bffa059cffc2fe9d69ebd16938b0b7948469"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6526697161dd7f4a432edb047f010283e683a34d2648d55b2e0d28f750bdcdfb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be66711176d9fbebb56bd23ad61925ea8dbf7c40edebceefc47701896ac2e87c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97d6fffe1d318dc38a759b924f8006406f2c27f9e1fda77138411945654c97af"
    sha256 cellar: :any_skip_relocation, sonoma:         "4700a82e8f820f45d499e6e22496edf5bc5412547e85d0a8a1f31ac8d4497fa6"
    sha256 cellar: :any_skip_relocation, ventura:        "b31b9a0a5b0cc3dcdb4fa7fd4f44f7f85f311ac3b4b63e2be54bb532351730bc"
    sha256 cellar: :any_skip_relocation, monterey:       "610ea12aaa31ee33885fa0a4e3b141a46f1a7516d435eb8901703c3fe84c1673"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92491a82121014581bdd4687f8891f02fa99ac02fcb24df8e725f1b36145d003"
  end

  on_macos do
    depends_on "coreutils" => :build # make install uses `-D` flag
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    sbin.mkpath
    man8.mkpath
    system "make", "install"
  end

  test do
    system "#{sbin}/quotatool", "-V"
  end
end
