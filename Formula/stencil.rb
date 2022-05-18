class Stencil < Formula
  desc "A smart templating engine for service development"
  homepage "https://engineering.outreach.io/stencil/"
  url "https://github.com/getoutreach/stencil/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "4b3019a99c70751e7d670d911cf8e20dd827caeb1907730425479bc7824770cf"
  license "Apache-2.0"
  head "https://github.com/getoutreach/stencil.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/getoutreach/gobox/pkg/app.Version=v#{version}"),
      "./cmd/stencil"
  end

  test do
    site = testpath/"test-123"

    # Create the directory and change into it because stencil doesn't _currently_ do that for you.
    Dir.mkdir(site)
    Dir.chdir(site)

    system "#{bin}/stencil", "create", "templaterepository", "github.com/myorg/#{File.basename(site)}"
    assert_predicate testpath/"#{site}/manifest.yaml", :exist?
  end
end
