class Stencil < Formula
  desc "Smart templating engine for service development"
  homepage "https://getoutreach.github.io/stencil/"
  url "https://github.com/getoutreach/stencil/archive/refs/tags/v1.14.2.tar.gz"
  sha256 "b313a6cb7e6b4512a7bf483e52af650d10b87c302b1359451fa976be194443ef"
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
