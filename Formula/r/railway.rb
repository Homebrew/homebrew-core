class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "91685e757470aa42b744e0475503b40b2e44e9a826fb1931ec34ce908e262bc5"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57c46aee54dffe0ac9b19d2ee1bf15a75ff7f70679046f47785cf711dd32d84e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67a896cb5005c2ddf049904d0b098d8aefe88b4bc7fb3550dba72dc6ad3a9e84"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e95829d9ffb613f4b9e9e9a2c69529d7c0249c5264b2e25e686a6945603d7d0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "128233c896d7b63fbee7eee7c791569e5ef1f4b8509968ffde566051a9790b65"
    sha256 cellar: :any_skip_relocation, ventura:       "09e250b4775fe90f8be841396f28f8d2d88b1af7725bd8a1e0f287dab07f4d5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23f6b79ad7b24e520deb8a9e10415b69b95e72b74830498cd6e8c66d89c238c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "431eaa6624b241d5ab6cab20f1ad8e1b12403120019208dcfd2d0225a74bcd3f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railwayapp #{version}", shell_output("#{bin}/railway --version").strip
  end
end
