class Stencil < Formula
  desc "Smart templating engine for service development"
  homepage "https://engineering.outreach.io/stencil/"
  url "https://github.com/getoutreach/stencil/archive/refs/tags/v1.22.1.tar.gz"
  sha256 "ba10da08433dc62765e7f29a4f6dabcf402c92a98656991969383e5892a1ef23"
  license "Apache-2.0"
  head "https://github.com/getoutreach/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46a3693d03644196dcb7cb1308496df76e5f38a1809ba599e1e315e2baf1776c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb144838071ffeb424d833b76954b8f3a3ba1d88d09f1d8bd016164f003c0220"
    sha256 cellar: :any_skip_relocation, monterey:       "e512d8e04ce2f9b74917c6a42fccbd8faf8bdf82cdf5b3a199f7b5845349c687"
    sha256 cellar: :any_skip_relocation, big_sur:        "2345cde2ca6e8f07dc2a668d19bffc9a2b50c3794c54a637ec9eadebe4a49819"
    sha256 cellar: :any_skip_relocation, catalina:       "5ce8cdc10178d4832976c10c6bc60c38b470aa6016bdd929ef2366e07faf83c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb0ecaea5e663e3b707b8b8040fbec75667bfcdccd2e602b08f64a4455d5f0fe"
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
