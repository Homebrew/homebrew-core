class Stencil < Formula
  desc "Modern living-template engine for evolving repositories"
  homepage "https://stencil.rgst.io"
  url "https://github.com/rgst-io/stencil/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "653d9c5faea41365ba18006467378cdde05e6e63c77a7aaa076168fc0889ec87"
  license "Apache-2.0"
  head "https://github.com/rgst-io/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edb89866ce1167db591f573c1eaa2ef5c984c3663b9b78aaeff907722775f8f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27503282809deef960658a972008065c5621600b8c4c8d65d97fc0e89c0f33f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fc568999c7229d16a61068f3c53fcc65629c0f01ce1a457c3af8e80ce8f87ad2"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e5dc73c1fd34f532e204fe44a6b536a9434567b4465fe04f6c6537baccf9270"
    sha256 cellar: :any_skip_relocation, ventura:       "c035a024d7a6763391538073ba5439fb647ce7954583d94c0bbad59b4267c0ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdfc06395a1dee7ad16261b1478cd43e141715533791e45504c616bd15226de0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8e19f32107a89c9b8da0872cb527bccf43c138ae761f6960771a2c4219fd92b"
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
