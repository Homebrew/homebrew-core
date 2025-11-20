class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v3.0.4/xmake-v3.0.4.tar.gz"
  sha256 "b6968dbe266029987bee0a389175f8898042c0bd38f279befc40adaf8e67ce04"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01dc01361c4cfc17376c214e683f5891d0209218a57d58e611ee57c53a9f0fa0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83bc61a29e6c23c44d62adc7c8706522d1f48cc9cd9dc90d3cbbb75db39fa92e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42e55fa3397900ac95d2ccb30380045e0dfe17ef5ff9436d46344f7112d50c83"
    sha256 cellar: :any_skip_relocation, sonoma:        "04ff3cf92a32fade36a76f8f8e98a42544ae05ac0a20504c73a83823e8a22add"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9340d26e9ad89d242c35eeb67b0abdf3e8346f9c1c2edac916e623eefa6a1b95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a63c23de7fb79c9e22639f794f781ec952cec10e2857698b62db206bb0e2e69a"
  end

  uses_from_macos "ncurses"

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
