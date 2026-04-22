class Stencil < Formula
  desc "Modern living-template engine for evolving repositories"
  homepage "https://stencil.rgst.io"
  url "https://github.com/rgst-io/stencil/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "f8748e97b05c21b48fc4335e99d5418703e0a8eb8a8e7e4dd9e57f5c7fef5df2"
  license "Apache-2.0"
  head "https://github.com/rgst-io/stencil.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f9ad8d6f502672e72445f800c3f1a097271327669b75e7fda892f32a5873c96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89cf0fa20256333153c095e46614aba9d50dd086b7673d5ee8be6c07a7a6bd08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "371b165821da6b2cb09c6bf7081d2955735fa4c98a2c24e8cbcb2863eec7851a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b7f753a4d90fd395f072bdc12dfac0252e0082acaf7c24942a959fdee3aa191"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f412c1f1b66d81d69dac56eb46cbd9984b319f716302b43d8eaff68a990f0114"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc7e8a9d19b596d082f684f3f6a08c01bc5c1d9d974ed013419149dd03fcea31"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X go.rgst.io/stencil/v2/internal/version.version=#{version}
      -X go.rgst.io/stencil/v2/internal/version.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/stencil"
    generate_completions_from_executable(bin/"stencil", "completion",
                                          shell_parameter_format: "",
                                          shells:                 [:bash, :zsh, :fish, :pwsh])
  end

  test do
    (testpath/"service.yaml").write "name: test"
    system bin/"stencil"
    assert_path_exists testpath/"stencil.lock"
  end
end
