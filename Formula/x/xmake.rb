class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.9.8/xmake-v2.9.8.tar.gz"
  sha256 "e797636aadf072c9b0851dba39b121e93c739d12d78398c91f12e8ed355d6a95"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6601c16227ede4ddca887106d9258f1e2bed8bccc3b603aeb9c2cb685b40033"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bda24b92c186dd4bcae8e933568ad775f143f55802a4a472f5e5575c38c57b5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cb20e6cc261ae50e26f2ba2f4d886124b8f858c3d77b4c529cdb86033cee573b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3bcd6cd5aa1e09f03b4ab05fca6d420d997eee8949c356c44f6a18cf5586e14"
    sha256 cellar: :any_skip_relocation, ventura:       "60d6963c2566430e0c4b83cd2d641d5203f0297db1ce0482e05d1483a033b8c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89e98ac175d28addacbab53a8a9c6b92acc68506b7630dde250394b52832bb26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95bbcd16aa0dd0ecad000481ee4b8193db9d34f8d43105f8c594e6867ba5c7a4"
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
