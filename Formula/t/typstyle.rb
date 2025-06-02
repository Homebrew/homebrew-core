class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https://enter-tainer.github.io/typstyle/"
  url "https://github.com/Enter-tainer/typstyle/archive/refs/tags/v0.13.9.tar.gz"
  sha256 "8c2952ee9d07b76ddeac56b34476e0b7b7ed6a84c5fe7aca1b07fb81a462c49b"
  license "Apache-2.0"
  head "https://github.com/Enter-tainer/typstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5fdef2de2edead485256f174722e2911365d5b5d7b6b38e39467cff7c93a083"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e36a4bb019053baef38db633ec4938321c2a38903f46835ad1faa359aca4984"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87990da1d3b3ba3f5aa76fb77f2ff5dd381032a35e280e9f7393c8832e6e8af3"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c5990c89a318cfa7a0a4f5298fd5366667a026997dbc07957831995cc168651"
    sha256 cellar: :any_skip_relocation, ventura:       "1f787770efe525ab3512275f2e6f4dd15bc5da4ba82d6a93ad8279fa5d8762c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "110d898ba1a43e53683e5e3e474735b03abb61a8ae38a20b8641bc9c5d0f3281"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7109e42cbf1a5519c824868e68422b4e075bd9e2245e7b1cffd65ea4511d81e9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typstyle")

    generate_completions_from_executable(bin/"typstyle", "completions")
  end

  test do
    (testpath/"Hello.typ").write("Hello World!")
    system bin/"typstyle", "Hello.typ"

    assert_match version.to_s, shell_output("#{bin}/typstyle --version")
  end
end
