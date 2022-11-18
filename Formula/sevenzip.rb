class Sevenzip < Formula
  desc "7-Zip is a file archiver with a high compression ratio"
  homepage "https://7-zip.org"
  url "https://7-zip.org/a/7z2201-src.tar.xz"
  version "22.01"
  sha256 "393098730c70042392af808917e765945dc2437dee7aae3cfcc4966eb920fbc5"
  license all_of: ["LGPL-2.1-or-later", "BSD-3-Clause"]

  livecheck do
    url "https://7-zip.org/download.html"
    regex(/>\s*Download\s+7-Zip\s+v?(\d+(?:\.\d+)+)[\s<]/im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "336a287e74813695435ba7726123db50672bc6c03379a72c4044c59b024a9797"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b9131e0986339f9986c7248c3101776279ddb390d287098ea5be1c84d6408d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15f4157398fdb03a9fc9ffa66eaf08abc72987d471b23ea22f5ab6700d7ba1a7"
    sha256 cellar: :any_skip_relocation, ventura:        "0f86a22b685653e831bf61c9c046422cb7754bcec41b17c92e943d92fef15b6e"
    sha256 cellar: :any_skip_relocation, monterey:       "64f2ea16a7c0f8591701914621b8ada21ecd6caa3ecf2568c8d4bc470edfae00"
    sha256 cellar: :any_skip_relocation, big_sur:        "22a8c3aa0647a1f8829c7e180cb2d6ac78b071925e8c06be361716626487fd6a"
    sha256 cellar: :any_skip_relocation, catalina:       "3ac4e9978c71f2452ded1a8ee0983b0710cc66d127ff2a95dc603b6211ed9df4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4dc467f705977b3a7d390a1248c691b9f4cee3c98d21647d55ef7c57afe28b3c"
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
