class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.8.2/xmake-v2.8.2.tar.gz"
  sha256 "ac0d3088bda466cfab39208b5c0697e747a92bd68bf967b815882bdbf4f144aa"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5f2bdfb8dc60c80622885c6424777fd82040baac0cac32a3ca44be62d678f5e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d63502c82a52e28748efa83fac78dee4119314decc03376eb337eb091dba0b7b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5b97a652a63f68e0f640303508dea4a68783570d082014133fae78cd10dc7dd"
    sha256 cellar: :any_skip_relocation, ventura:        "e6b4812ce92c31a666a760da39281a3130d83570048c1aaf74023850ef02e678"
    sha256 cellar: :any_skip_relocation, monterey:       "9e3f3a8ffad938d3a37b7dc719e7ad8158331c2e72c04583763df754d16b828e"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f9cabbed800a3f000346b1769eb86a34e7fbdc868e949bb8725d67900289366"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fbc35dd0c572696da673671b4ee34ca56090094f6645c008b35bd7db1d08d73"
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
