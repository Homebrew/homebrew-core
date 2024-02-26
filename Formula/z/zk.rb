class Zk < Formula
  desc "Plain text note-taking assistant"
  homepage "https://github.com/mickael-menu/zk"
  url "https://github.com/mickael-menu/zk/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "bd96f93d50e2e72ce05f36c3dab5b7942ae205756f26d4c68ba2a7ccc783abc8"
  license "GPL-3.0-only"
  revision 2
  head "https://github.com/mickael-menu/zk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3ab58eb9d649bad4f30052de7eb9875b186d6aa69b57c489c19a6eba6397b608"
    sha256 cellar: :any,                 arm64_ventura:  "1fdfd9fc01e2561c0bf16bd415da539afecf643552097523b53ce8e4407ccbf2"
    sha256 cellar: :any,                 arm64_monterey: "df2f05d38498a8bd1d4e7a975d7e50b389f4432fe1ffb4a3a259e2da5929aa3f"
    sha256 cellar: :any,                 sonoma:         "55cb1cef218ca538adf377f373b8f5cd95685fa319cfc7aa53ba975323bb65a7"
    sha256 cellar: :any,                 ventura:        "f84f2d2a5d443a8715e658e651cc587fbca96129a10401ecd65e72846ce60304"
    sha256 cellar: :any,                 monterey:       "d465773ec91007d9fcd6cd4d07867b42d51b2efc2998ca55fec7911b93b929ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e9be7234f54efdf2192cf9346b755df13cf99df1a54a8cfe332179035f2d043"
  end

  depends_on "go" => :build

  depends_on "icu4c"
  uses_from_macos "sqlite"

  def install
    system "go", "build", *std_go_args(ldflags: "-X=main.Version=#{version} -X=main.Build=#{tap.user}"), "-tags", "fts5,icu"
  end

  test do
    system "#{bin}/zk", "init", "--no-input"
    system "#{bin}/zk", "index", "--no-input"
    (testpath/"testnote.md").write "note content"
    (testpath/"anothernote.md").write "todolist"

    output = pipe_output("#{bin}/zk list --quiet").chomp
    assert_match "note content", output
    assert_match "todolist", output
  end
end
