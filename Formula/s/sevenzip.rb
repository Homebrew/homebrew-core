class Sevenzip < Formula
  desc "7-Zip is a file archiver with a high compression ratio"
  homepage "https://7-zip.org"
  url "https://7-zip.org/a/7z2301-src.tar.xz"
  version "23.01"
  sha256 "356071007360e5a1824d9904993e8b2480b51b570e8c9faf7c0f58ebe4bf9f74"
  license all_of: ["LGPL-2.1-or-later", "BSD-3-Clause"]

  livecheck do
    url "https://7-zip.org/download.html"
    regex(/>\s*Download\s+7-Zip\s+v?(\d+(?:\.\d+)+)(?!\s+\(beta\))[\s<]/im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1693819a308515fdbba7c429feaba6d7e54b8b33fd736a9429ba86178c4d9119"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "827903d5393cf2a7133ef1f77ffddbd9b6a2965a3cfa4184e58c9c70830645ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1316330166099a51f2378e50e35e5b459e961864e6b87a86bad3d327c378c61a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9de3c95cad8ee9623c11c49032ff3b46f1a96bf5f8ea135d5e6c68f5910390f"
    sha256 cellar: :any_skip_relocation, sonoma:         "d483673824aaf7cdcee1462ed5af1280f36d78b28711ba04cb085168a33f5b1b"
    sha256 cellar: :any_skip_relocation, ventura:        "3b505d473a2e42e31a1af5a18979da017bbdd513c82f61c0a50ec290848c9a9a"
    sha256 cellar: :any_skip_relocation, monterey:       "d9c9012ba656543db5561303a09b080a2ece88053c4c8a14a90ff061825bcc02"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a6f73420c63aa119439a9bd7fe0e60a487a815f4292fcca34a79f78e67c98bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a51b075cae0430ec542d5a8fee6b5866777a03f0f8238b0ad46b0e34c72af55"
  end

  def install
    # See https://sourceforge.net/p/sevenzip/discussion/45797/thread/9c2d9061ce/#01e7
    if OS.mac?
      inreplace ["Common/FileStreams.cpp", "UI/Common/UpdateCallback.cpp"].map { |d| buildpath/"CPP/7zip"/d },
                "sysmacros.h",
                "types.h"
    end

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
