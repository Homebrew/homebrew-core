class Superfile < Formula
  desc "Modern and pretty fancy file manager for the terminal"
  homepage "https://superfile.netlify.app/"
  url "https://github.com/yorukot/superfile/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "9903ba151abee629e6da4126cb4f6c73b693112632be366b8fab5ff17d15f14d"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5689f22087e482b856c109aacf8cd6a1f51211d859dd823c82bd59ceaad21d47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "710ac426a1439694849b20871b5c58b28eabd2c6f05988ae47684751245cadd9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5342aeafd08ef3008bc0b7c68c8ee33684bd0b2742738dfabef8115b4d969b23"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd1666051061f274e7db33614561f001c486f2fc3eb087304d303e1fd06f7188"
    sha256 cellar: :any_skip_relocation, ventura:       "4935c60a8e658eadbc4ce0bbd485ee29b4f416808ac456279c8b948ee1644cba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c2dd35dde21859d5274d373dfc5f8f2b69d5115580d44ff8bb5e756304a6bae"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"spf")
  end

  test do
    # superfile is a GUI application
    assert_match version.to_s, shell_output("#{bin}/spf -v")
  end
end
