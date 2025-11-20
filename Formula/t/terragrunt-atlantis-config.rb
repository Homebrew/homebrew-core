class TerragruntAtlantisConfig < Formula
  desc "Generate Atlantis config for Terragrunt projects"
  homepage "https://github.com/transcend-io/terragrunt-atlantis-config"
  url "https://github.com/transcend-io/terragrunt-atlantis-config/archive/refs/tags/v1.21.1.tar.gz"
  sha256 "eefc48f2bedc11c154c6c7e088bb10316d811b2d6b851b11d37d80f18a28e517"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9dec17aa158c10a82522b739705b0adf4ee38a3aa0b7ae1e557dba5bd403e73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9dec17aa158c10a82522b739705b0adf4ee38a3aa0b7ae1e557dba5bd403e73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9dec17aa158c10a82522b739705b0adf4ee38a3aa0b7ae1e557dba5bd403e73"
    sha256 cellar: :any_skip_relocation, sonoma:        "aebee1dd99ca225d24872c9deaaaa75e5d3929b5342290b377e0134eb10ab29e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c10183ff34a7f6f80a81d9922b6464941d199e15c177f5bb5bb3c1dbc8e0fedb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9792965a2e68d6c2310b8aca3ac9c56f9c20b46729ae79d9466bfc023fccd8b2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/terragrunt-atlantis-config generate --root #{testpath} 2>&1")
    assert_match "Could not find an old config file. Starting from scratch", output

    assert_match version.to_s, shell_output("#{bin}/terragrunt-atlantis-config version")
  end
end
