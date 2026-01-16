class Stencil < Formula
  desc "Modern living-template engine for evolving repositories"
  homepage "https://stencil.rgst.io"
  url "https://github.com/rgst-io/stencil/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "ebb5331f7f180a800ddf649b008c8f09bb85cba54ddc8137cad7320ebedd9991"
  license "Apache-2.0"
  head "https://github.com/rgst-io/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16c8f24f3cadd7c4e26bcb984bc4a559dab49810c59ec8a0b1002c0f1d1ad54a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aea6c9464f43cb3e1e8a55275551a1d1fd9af7f493bfa69b09f4bb946d0b56f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d50c46a56c4fae46449838e7fa699beaf15c88776e469fcccff549f464f6fc12"
    sha256 cellar: :any_skip_relocation, sonoma:        "317f664d67dc3f98b266943bbfd80059787c8d80a33d7c6e4691222ee5e2b818"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f28924ff5020242dcc71fd70a530b1a2e8c028831020f40edc84e50d79505aa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9372f0f2ec19131bdf2f0110d8c2957927f00e1188ef2c94ce46c5fbccaca011"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X go.rgst.io/stencil/v2/internal/version.version=#{version}
      -X go.rgst.io/stencil/v2/internal/version.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/stencil"
  end

  test do
    (testpath/"service.yaml").write "name: test"
    system bin/"stencil"
    assert_path_exists testpath/"stencil.lock"
  end
end
