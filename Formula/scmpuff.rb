class Scmpuff < Formula
  desc "Adds numbered shortcuts for common git commands"
  homepage "https://mroth.github.io/scmpuff/"
  url "https://github.com/mroth/scmpuff/archive/v0.2.1.tar.gz"
  sha256 "6855562be9788a0fcf69102546f3bf8ccac063086d28a9a3f1ab4947e9dd08e2"

  bottle do
    cellar :any_skip_relocation
    sha256 "68db211b016db1cfeab8359edc1f0643551cdefddf309ffa09d707fda1ff8a16" => :mojave
    sha256 "a09454488aec6c6990f258473c1cdcd722b7f615fff662d040acee353df9a0ee" => :high_sierra
    sha256 "3532b6f0d95310bede8ccb33b13ad4dbb657563744ea3accf641fa27e34a37b4" => :sierra
    sha256 "3dd4f5a5a6760a6e92c57e69dda4e689eb33787ebbbad01482a3ae0fb26c4445" => :el_capitan
    sha256 "fc633135611451e73386836b3d2a9bdd63b25065bcf6cae4228239af0fc05a04" => :yosemite
  end

  depends_on "go" => :build

  def install
    mkdir_p buildpath/"src/github.com/mroth"
    ln_s buildpath, buildpath/"src/github.com/mroth/scmpuff"
    ENV["GOPATH"] = buildpath

    # scmpuff's build script normally does version detection which depends on
    # being checked out via git repo -- instead have homebrew specify version.
    system "go", "build", "-o", "#{bin}/scmpuff", "-ldflags", "-X main.VERSION=#{version}", "./src/github.com/mroth/scmpuff"
  end

  test do
    ENV["e1"] = "abc"
    assert_equal "abc", shell_output("#{bin}/scmpuff expand 1").strip
  end
end
