class Stencil < Formula
  desc "Modern living-template engine for evolving repositories"
  homepage "https://stencil.rgst.io"
  url "https://github.com/rgst-io/stencil/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "f0aa1ba60abb3f6543766918d6fe3df58ba6fa1f9638f6d1b324ac92db0a05c8"
  license "Apache-2.0"
  head "https://github.com/rgst-io/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f065a5b1180d0fb469bec30d057ae7f67c8bea07d84236028ea9f64765832013"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a958af4b772590730cea2ce05f5f45ef7f76d122df71b753d49ca7d7fe4ea24"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f63fa93d184294d89b60f8a1da9f921fd04326984b112aac59da1c4ce16c0abe"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a4148aa8ef22e3822d7eae9cf49dd5d1b34b510e78c16613f4c4e673b1abde5"
    sha256 cellar: :any_skip_relocation, ventura:       "4533142f36ed305b47969656cd1cbba8ae79062f697ef179db6f8c00b369f769"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be330cd1924e13950e11943a335795a1381fef982d056ba1de5281b78e74056e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X go.rgst.io/stencil/v2/internal/version.version=#{version}
      -X go.rgst.io/stencil/v2/internal/version.builtBy=homebrew
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/stencil"
  end

  test do
    (testpath/"service.yaml").write "name: test"
    system bin/"stencil"
    assert_predicate testpath/"stencil.lock", :exist?
  end
end
