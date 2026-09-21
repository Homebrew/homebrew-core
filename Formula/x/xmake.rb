class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v3.1.1/xmake-v3.1.1.tar.gz"
  sha256 "e67e6692bdf8fcb10cdb2cc78c0e8f0ae6c86ad3e3fc532880feca49eefb74b8"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "479e7fe2f1cad08e5462196304f22bb797214ef59e47790b536051b06a82d391"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e55ab5f16a080f6e77393795f8bfad46bd466427e293e1e9a136870085f2d855"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e1ae8eca964dc9bf1a784f9020480afba1653bed4bb54a251dad691b46184e58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "76fa1647e619b5d4c038f041077acf3f96cf05df977edbb1bbf89d5ebb4c7a3b"
    sha256 cellar: :any_skip_relocation, sonoma:            "afde5f5fc8bddf25cc92c664bb690d9015614a56fbc35c0d5d9c93d14e64c2b5"
    sha256 cellar: :any,                 arm64_linux:       "8c4311435342921ab4ccf91ff5b4120e7d8946c870bb7b739aa707882cdc1153"
    sha256 cellar: :any,                 x86_64_linux:      "a87e405c40405696cd84266da57a69fc70d5ec60564280b2d63faa40e5b4073a"
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
