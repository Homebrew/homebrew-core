class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "e95d6a8923f1fe3aff402156c12d037db46c2f99aa9c95099ec23c0c7ebeca1b"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "534fd31be00de5a2e3c2789d60f25fa714aa9a9c07703cbcb314732499944460"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d6052c6cd4a8aeb3740a73b3d83e5ce98abee0bebcad23074765b3684dacbaed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b6a48a1c70ec98fc27102a3e45ba985cc397bacc549dcc90088423c4b47a3785"
    sha256 cellar: :any,                 arm64_linux:       "49234580544332500ca5f69b8ae8ed1807f71c91e3dc85be3daf2b227e097212"
    sha256 cellar: :any,                 x86_64_linux:      "3cb3ef6e26889b3ee240ad14281a4dcb4427d87a4403068b16a290ddb0258b1f"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"rover", "completion", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("#{bin}/rover graph introspect https://graphqlzero.almansi.me/api")
    assert_match "directive @specifiedBy", output

    assert_match version.to_s, shell_output("#{bin}/rover --version")
  end
end
