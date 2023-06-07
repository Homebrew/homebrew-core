class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "be67723224d4607ed973a6c3994b573454118867362679caf50415ba2053cdd4"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c173c755e5b8d0db33ad9176150b63acb5ce4176f0c4186836a22779e4587eec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93db30f96b39fe747b7bb7d7a8c97c6f12a2cbf98d7eae98aeba44086f9e7411"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fcae863bee9f43fc983b9f1c65ea3390d0d859f25fa9c14f8a63fc2bd25330ea"
    sha256 cellar: :any_skip_relocation, ventura:        "f4e038b804685c3781a701913bb62af1abe523fd7d6e2907c40e41e23f357386"
    sha256 cellar: :any_skip_relocation, monterey:       "d421765f33ef5fd8c631f994e1c5caf9a99fae8882fa0e2d76c619c0a22ad788"
    sha256 cellar: :any_skip_relocation, big_sur:        "d22c13256e3be29d4bd98dbbdbca4976af81d7953779bb44fbf10149d11070fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bd81b8d9ae2905aa4929e4c6812d55655b591e776614b74e6bb4356751f4626"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/rover graph introspect https://graphqlzero.almansi.me/api")
    assert_match "directive @cacheControl", output

    assert_match version.to_s, shell_output("#{bin}/rover --version")
  end
end
