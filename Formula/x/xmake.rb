class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.8.7/xmake-v2.8.7.tar.gz"
  sha256 "8c7a8c6f77b1fc1705e785624e9a1e944716844a8378fece7341de27b99f0b89"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ffc200e56ccd68fb159387214e5ce266df8c12345ab51bdadb117ed857db881"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cff383e49cb3485ab564a9530be837b99165f73e0f9cc441db7abf163ac17474"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19e0f0eb3d86947f3f4d84238956f1980fd811397a7a2b9492a971be355bd1ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "32c952ea2a4c3f6504f90c0aaa054673b7da27abb1f82384ec8064bab87d12f5"
    sha256 cellar: :any_skip_relocation, ventura:        "c4db7778d8c60e3d7b9a130fa2e5cb1ff0baa14e3bd84736fbd5ca568d5d910b"
    sha256 cellar: :any_skip_relocation, monterey:       "ee5977c082b417ea55c5fa63ecd342dd041b9b39db48f27403a97e048351381f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16c3acf3a4259fd2b031ad054422ab23369fafc30310ef15b5bc2c215416f493"
  end

  on_linux do
    depends_on "readline"
  end

  def install
    system "./configure"
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    ENV.delete "CPATH"
    system bin/"xmake", "create", "test"
    cd "test" do
      system bin/"xmake"
      assert_equal "hello world!", shell_output("#{bin}/xmake run").chomp
    end
  end
end
