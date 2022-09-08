class Stencil < Formula
  desc "Smart templating engine for service development"
  homepage "https://engineering.outreach.io/stencil/"
  url "https://github.com/getoutreach/stencil/archive/refs/tags/v1.26.1.tar.gz"
  sha256 "553c52b13cd4191293e998f622cf0677e123cc57c85633d61aafd3555a12e6a3"
  license "Apache-2.0"
  head "https://github.com/getoutreach/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7e405bffaccaad5b43e75881f0344f3a9c692ff8f67ec85036716b89c9c44df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c52b14396f4806fee12f3a6d852bfa94d5e530b3079226b1809c6d548392055"
    sha256 cellar: :any_skip_relocation, monterey:       "a5424f272ee27b89caa13da6cc4ead751a0ac123fa58f2f9b0c593ef1db01bf3"
    sha256 cellar: :any_skip_relocation, big_sur:        "18f2b156abc416037d504b56831740938ddfd4420b8dda5de880aa901bfa379c"
    sha256 cellar: :any_skip_relocation, catalina:       "e078005a945e71299d3bc9d2c68870d3daf76589c005f116f8030d2552ff07fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e336ef2bdd47a5c169a50feada13552e0b353299110263fcfe8d1ad4316dab0e"
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
