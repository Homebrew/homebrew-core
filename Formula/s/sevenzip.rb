class Sevenzip < Formula
  desc "7-Zip is a file archiver with a high compression ratio"
  homepage "https://7-zip.org"
  url "https://7-zip.org/a/7z2500-src.tar.xz"
  version "25.00"
  sha256 "bff9e69b6ca73a5b8715d7623870a39dc90ad6ce1f4d1070685843987af1af9b"
  license all_of: ["LGPL-2.1-or-later", "BSD-3-Clause"]
  head "https://github.com/ip7z/7zip.git", branch: "main"

  livecheck do
    url "https://7-zip.org/download.html"
    regex(/>\s*Download\s+7-Zip\s+v?(\d+(?:\.\d+)+)\s+\([^)]+?\)/im)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab3975bc6b23804b1f5f69a15d111ab6e0902f3243dee0a31144ad2c43f2f345"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91a7cef5b9997aa066cd08365d21f62533d29eb9e1dbe866afbf0028dd41219f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d302ec0f78738b4928d3892786645e9d8d54d409429e846b72cc3eaeda1e4731"
    sha256 cellar: :any_skip_relocation, sonoma:        "98ec0655ef9bcceb227440709028a063548d635b931e2371235dc348574c3126"
    sha256 cellar: :any_skip_relocation, ventura:       "e1873b78a25ce506db2b641eaf50699be4aabe0c36eab3434519b09d0b6c3d8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afd02970b919ed47c1288acfa53ced5cb1b6193c8f3dfd5b9d59de9396143cba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cd9b10b9406cf7bfdc8616073f63f5df3f79063e6f57df4756b5999e0739e9b"
  end

  def install
    cd "CPP/7zip/Bundles/Alone2" do
      mac_suffix = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch
      mk_suffix, directory = if OS.mac?
        ["mac_#{mac_suffix}", "m_#{mac_suffix}"]
      else
        ["gcc", "g"]
      end

      system "make", "-f", "../../cmpl_#{mk_suffix}.mak", "DISABLE_RAR_COMPRESS=1"

      # Cherry pick the binary manually. This should be changed to something
      # like `make install' if the upstream adds an install target.
      # See: https://sourceforge.net/p/sevenzip/discussion/45797/thread/1d5b04f2f1/
      bin.install "b/#{directory}/7zz"
    end
  end

  test do
    (testpath/"foo.txt").write("hello world!\n")
    system bin/"7zz", "a", "-t7z", "foo.7z", "foo.txt"
    system bin/"7zz", "e", "foo.7z", "-oout"
    assert_equal "hello world!\n", (testpath/"out/foo.txt").read
  end
end
