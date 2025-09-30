class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.10.0.tar.gz"
  sha256 "e20c95b6a1db1271f885ba8e138df9592dac33f41a21dfe610e0a9c2deff4ad2"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d7182ab5c03e7b64bc48c52746671fc8b80f6a521a3b14f6194a9243ab874f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "775f7ef4ab61553bc196a01c064ec53d3030c829b739c91d5b87d3f0e9e1f1cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2eeb96b9a8d5582b1f245367756d17cbaa177ddb1c57590067d5d0833caca4be"
    sha256 cellar: :any_skip_relocation, sonoma:        "63213b6b606a93706e424b08663db8791cbd830e3d17c91e74bacd410809f643"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5cae4f7830f00419ed3c1c509bde23c4f7d0c66237e26845d98a8427e074be7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8af6d560f2d4c05eaf22e00bedea1aa892635019b163cb5031943f7ae605050"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end
