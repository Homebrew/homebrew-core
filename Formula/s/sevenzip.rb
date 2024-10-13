class Sevenzip < Formula
  desc "7-Zip is a file archiver with a high compression ratio"
  homepage "https://7-zip.org"
  url "https://7-zip.org/a/7z2408-src.tar.xz"
  version "24.08"
  sha256 "aa04aac906a04df59e7301f4c69e9f48808e6c8ecae4eb697703a47bfb0ac042"
  license all_of: ["LGPL-2.1-or-later", "BSD-3-Clause"]
  head "https://github.com/ip7z/7zip.git", branch: "main"

  livecheck do
    url "https://7-zip.org/download.html"
    regex(/>\s*Download\s+7-Zip\s+v?(\d+(?:\.\d+)+)\s+\([^)]+?\)/im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "65c7e8d750dda852ba3dd5a115dec5d48f325f0ba4c7a8613d8b419a036b7025"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e4c37bf5f69c3ab0d8fe655309460979fb7d386d8a3ab8a065f3f373d13c3d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2adc083c39a4d5ea0c9ac51d7b9586a6674d889b477278491624258c090df53b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7cc362f47157bd92d5dc6a5ec610152f84139415dc33e62dc650edd63e7ddf1"
    sha256 cellar: :any_skip_relocation, sonoma:         "6876934f5b0b35008adb3ecf9ee4ed5c35836ed79abb2a44d7abbe9608e3c7a5"
    sha256 cellar: :any_skip_relocation, ventura:        "5f23f76b0f729ce8917906fefdad7ac15d25bf8e8f438b80e11bdd042afbac29"
    sha256 cellar: :any_skip_relocation, monterey:       "68b37e835438f9c97b66c3e558342a6b0cc9bc8c9bfa419bbe2e68ee4c976a55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e409a242b3268db2c404b35524ee7131cc6f750fb9cc6f3b934280ab46454fe"
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
