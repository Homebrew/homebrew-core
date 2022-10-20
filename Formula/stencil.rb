class Stencil < Formula
  desc "Smart templating engine for service development"
  homepage "https://engineering.outreach.io/stencil/"
  url "https://github.com/getoutreach/stencil/archive/refs/tags/v1.28.1.tar.gz"
  sha256 "4e794c8ed578c0b64167b5265a26763ce5f949be906adf81acf0e07f795f20e1"
  license "Apache-2.0"
  head "https://github.com/getoutreach/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed834947acdb56b2d048ae81b55ceac7d8dd2be1c90bdd82661543a992b9091d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc5811b33320b34f9531901b447ef1252bc7850828ecba05d21ff8ceb3ba7053"
    sha256 cellar: :any_skip_relocation, monterey:       "c0bb98b53b446fb0a330c19232c357185de72af29c9967e9a2ac41d2f96238d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0b3166c0eca737a0761891127d75233dae82c0bcbe66387cf7571169f981dc6"
    sha256 cellar: :any_skip_relocation, catalina:       "2f7fb07b7ff5e6d96f85e99931022a0a67875767ae71b6cc88c520cc20872b2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "191375c9d35882fd3b5506c67e6e6d6328f1375edf458c00daddca826e095e4c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/getoutreach/gobox/pkg/app.Version=v#{version} -X github.com/getoutreach/gobox/pkg/updater/Disabled=true"),
      "./cmd/stencil"
  end

  test do
    (testpath/"service.yaml").write "name: test"
    system bin/"stencil"
    assert_predicate testpath/"stencil.lock", :exist?
  end
end
