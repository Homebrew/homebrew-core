class Quotatool < Formula
  desc "Edit disk quotas from the command-line"
  homepage "https://quotatool.ekenberg.se/"
  url "https://quotatool.ekenberg.se/quotatool-1.6.2.tar.gz"
  sha256 "e53adc480d54ae873d160dc0e88d78095f95d9131e528749fd982245513ea090"
  license "GPL-2.0"

  livecheck do
    url "https://quotatool.ekenberg.se/index.php?node=download"
    regex(/href=.*?quotatool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "745e9918ee9275d034efcbfe3907e48b760e6e22fb0b6381b120592bfe9b92af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33cf581ce810cb4704669a05ee01b5cc963008f02393db65453ef06216ed257f"
    sha256 cellar: :any_skip_relocation, monterey:       "23e979daccf52492fa2a80f705954390cacc2aa835bb4337a6623ab62edf0bd5"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5dbc4f83caec774f6f05d65515c51bd8963c28415020698666d534030e91b23"
    sha256 cellar: :any_skip_relocation, catalina:       "b8787cedb9e50c5ea14b10fa2e6cf9ec948e7842a97d5e7212abef0ea87e26c6"
    sha256 cellar: :any_skip_relocation, mojave:         "2d2b6f53466ec7b211f44b0319966b7120e3bbf0e1d57c1f0ae3d272bc8f4ce4"
    sha256 cellar: :any_skip_relocation, high_sierra:    "bbf7543458972806f3c15b25bf7cd71276159b54ae1ada3beb12e6d29328ec0e"
    sha256 cellar: :any_skip_relocation, sierra:         "4d04c382c8cf8b0376b34ce12813be06e879fdf6b60711cf90643d08887304fb"
    sha256 cellar: :any_skip_relocation, el_capitan:     "da5c90f85204fa90a38da073765ec5c0f0a20333bcdcd131d79b682afa74233f"
    sha256 cellar: :any_skip_relocation, yosemite:       "8af3549d42247f0b79458c96978f8f5e5fbe04cc1c0dd86f84accdf03e8e510f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "296d3ea40771bb113792f0bd6b57cbcba371d9c80d95271b29474a1bbcd16194"
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
