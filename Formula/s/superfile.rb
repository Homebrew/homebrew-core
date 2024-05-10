class Superfile < Formula
  desc "Modern and pretty fancy file manager for the terminal"
  homepage "https://github.com/MHNightCat/superfile"
  url "https://github.com/MHNightCat/superfile/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "aa4aadc54ca7b16c2715148524d241c940c4ab0b8e0610ee71ed1a8708c116d7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da4586d518e7b75de0df5cb08e04b84c697dea80dfcbb7f824f10021afa8a2f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0fc35dfd52c7619c819f530a0bfe978847427079887014c81318d28564150162"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57b7651ccf69055d1c7fd9ef7063c1daa4a10b51ad98f964325c62adbc74168b"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf48acbf609777511cbaa45c08efbc151ed0000e906fac40da21fe559b61795d"
    sha256 cellar: :any_skip_relocation, ventura:        "00d8f6a350e7304f64614a82f95c222969d65ed690305d76b0a3da9024b4d5e8"
    sha256 cellar: :any_skip_relocation, monterey:       "0c80fcfce7375ab666fce05b04795731d9d2557cbfd87d1faac25e810bfeaa03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33df4c52bf3d6f7913af3d45627f8269cf269d29d6a2d8b9fe0cc84ca440128b"
  end

  depends_on "go" => :build

  def install
    cd "src" do
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"spf")
    end
  end

  test do
    # superfile is a GUI application
    assert_match version.to_s, shell_output("#{bin}/spf -v")
  end
end
