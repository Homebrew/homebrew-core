class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "0710306b55bcc8408835040b611f337432702b17b59460a957f6d7aef640d07d"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a269a7a23e565e4f2c2fd58d1d4c5d935b4fc833c85b6756cc40252d7f6e413f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bff6299918aa5102f60b73c0cdc73d85de2f9e567c314d1bf4e7adc28b679675"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12fa0206f19f017b960ef3b58c3cafa8b9064524019e7e19355f7fece22e5a81"
    sha256 cellar: :any_skip_relocation, sonoma:        "deb22ea3a310dcfb3321c045d46da8bd6979e58badd287152e0bd5b0cd8e18fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d5c6f57c92fb70c0e4530820ea0bd6897baa690770244f92ad2bdec83349047"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31ce8fe6aa07aa86f5c2b5f1c3303fb01df9111c0baddcfbd8aa6a2edf5fdd91"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
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
