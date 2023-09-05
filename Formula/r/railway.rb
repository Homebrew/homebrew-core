class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "7411b02c2353af459d9bbbd809cbdf13df333c84e60d383301e8ff2415bac0b0"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ad4b9dfb47c983b27735a09f29f20bce118901cefab3a0402b59e7275cacf28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c8e60f6f335d525bfb0a833138b70cbc1658677e37550d92c4abe72b92326d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c988b30313d1883df2dc72a257c8a60d75c74ce36f649b2c8350d5224f171c2c"
    sha256 cellar: :any_skip_relocation, ventura:        "569f78bb00f096556c4c11577faced802f9baad387a1e5b87bfdc014e8eb06dc"
    sha256 cellar: :any_skip_relocation, monterey:       "6d6326443a2b23be759358ed3713af0f5576a308b49c792c3754d1f9f62375d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "959f1f52fb4a2b59586acc706255225051907cdccc81ee85cc51cae0518dabd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "261716596235f9ca89b2edaedbfcd0ec2fce186cdff95ebd83bf487c78d47913"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Install shell completions
    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railwayapp #{version}", shell_output("#{bin}/railway --version").chomp
  end
end
