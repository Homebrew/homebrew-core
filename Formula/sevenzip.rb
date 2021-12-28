class Sevenzip < Formula
  desc "7-Zip is a file archiver with a high compression ratio"
  homepage "https://7-zip.org"
  url "https://7-zip.org/a/7z2107-src.tar.xz"
  version "21.07"
  sha256 "213d594407cb8efcba36610b152ca4921eda14163310b43903d13e68313e1e39"
  license all_of: ["LGPL-2.1-or-later", "BSD-3-Clause"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5174e685a52d70c63f50c88155b390c06ba17cc9e6ca8722f4f25cb24642aa2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2bfd173b41f769a90bdaaab4f7e3a36d8d51e27d4e21d4306404da69933e173"
    sha256 cellar: :any_skip_relocation, monterey:       "6416645cca5a7d283e30195382a57b8795443c89d893fc630ea34dd74c294cac"
    sha256 cellar: :any_skip_relocation, big_sur:        "f05f9a07c8336445fc759c45b983c90d6aa2ab6caa3d0368ffc1f0b58513e79c"
    sha256 cellar: :any_skip_relocation, catalina:       "b82b08afb32d7b42bc1cbd4011f27612b73e8e8cf971ab006a594bdd2fc83ec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8464c7f14fcc179f0fc022aac54f1ad290aa52d2da3dadaf50d602c8af59bde"
  end

  def install
    cd "CPP/7zip/Bundles/Alone2" do
      mac_suffix = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch
      mk_suffix, directory = if OS.mac?
        ["mac_#{mac_suffix}", "m_#{mac_suffix}"]
      else
        ["gcc", "g"]
      end

      system "make", "-f", "../../cmpl_#{mk_suffix}.mak"

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
