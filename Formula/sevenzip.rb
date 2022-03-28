class Sevenzip < Formula
  desc "7-Zip is a file archiver with a high compression ratio"
  homepage "https://7-zip.org"
  url "https://7-zip.org/a/7z2107-src.tar.xz"
  version "21.07"
  sha256 "213d594407cb8efcba36610b152ca4921eda14163310b43903d13e68313e1e39"
  license all_of: ["LGPL-2.1-or-later", "BSD-3-Clause"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "979b01b5e8c9c9918a0f3c5a611462fc4aae591ffbe960675bc3970f81549333"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "05d509acd57fc81dddea1662f11d87cb7ed35ed53e0a69da9d3119793cb4a206"
    sha256 cellar: :any_skip_relocation, monterey:       "76952c80ac0f3cec5616904f959679d5e56fdc507725da735030d74eec71d2a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e5d28a486b4e10407f4b27ea1608092a2e91fafa0c63830e7a11bf534f6174f"
    sha256 cellar: :any_skip_relocation, catalina:       "798b0be8c9dd1a95a09d22d3d32af9a3b07ea8e089afa07eb6277b0f278c042b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "966bd2bb908e43a34a94df6b92ab97879b91ff0924adae57caa8c3babb3f0c8d"
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
