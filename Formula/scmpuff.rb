class Scmpuff < Formula
  desc "Adds numbered shortcuts for common git commands"
  homepage "https://mroth.github.io/scmpuff/"
  url "https://github.com/mroth/scmpuff/archive/v0.3.0.tar.gz"
  sha256 "239cd269a476f5159a15ef462686878934617b11317fdc786ca304059c0b6a0b"

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
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    (buildpath/"src/github.com/mroth/scmpuff").install buildpath.children
    cd "src/github.com/mroth/scmpuff" do
      system "go", "build", "-ldflags", "-X main.VERSION=#{version}",
                   "-o", bin/"scmpuff"
      prefix.install_metafiles
    end
  end

  test do
    ENV["e1"] = "abc"
    assert_equal "abc", shell_output("#{bin}/scmpuff expand 1").strip
  end
end
