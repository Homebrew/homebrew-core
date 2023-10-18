class Quotatool < Formula
  desc "Edit disk quotas from the command-line"
  homepage "https://quotatool.ekenberg.se/"
  url "https://github.com/ekenberg/quotatool.git",
    tag:      "v1.6.3",
    revision: "a32e83b5cc414a0a28d4e703f6012349a92c2d4d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3719605c12e295bafe7d4128b91483615bb7d77255d03174f20eaa53a8143872"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a370d1d4a0a8427ce965fb1f2a025744d2fb62ca9cee41a7def60659560dc978"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff62f0d5ca83dd416cf61bef0b9f95dfd56a9004dc0a53bd3b494764e3f33808"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba0e322a5e78b925f96f4e02e245dc734e5d3e748789d4dc1fb64df3e93f5af7"
    sha256 cellar: :any_skip_relocation, ventura:        "05023c93011d4d1ee44908f6897dc58119cb365fbf5fd8f35b1c66ff3086f08d"
    sha256 cellar: :any_skip_relocation, monterey:       "5f5e400588578a723c006145513aaf8bdb6f5db2d3e8ac7dd972369247e35d71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77effdde3aef3a46ff756aa1840b11e0e71d9597d7bf8fc41b047a79ebcce768"
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
