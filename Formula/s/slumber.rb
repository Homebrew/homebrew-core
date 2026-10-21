class Slumber < Formula
  desc "Terminal-based HTTP/REST client"
  homepage "https://slumber.lucaspickering.me/"
  url "https://github.com/LucasPickering/slumber/archive/refs/tags/v5.4.2.tar.gz"
  sha256 "2b5e484de05008236ad7d55a923ff41e6bb04eb7629ee26ac240c08a9ca4e7e9"
  license "MIT"
  head "https://github.com/LucasPickering/slumber.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2efb531c109281581433347e44ff2edf2c2d380441584faf3e9053bc8b893934"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d8abe7f1c9454e6da7fc6b85c082cb73c160114e7dea30cb62ff511378010032"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4f8a6353a8ebc57f4fed487e557ab1139366d5a25dda1b9090934a1df811ead9"
    sha256 cellar: :any,                 arm64_linux:       "e7e67062384f19cd2363bdd007ee1615cf0f48b764faa9ec4ed3c2d622c1dd0e"
    sha256 cellar: :any,                 x86_64_linux:      "df426dbf81c82ebb1731d6c3374901e254ab0d250efb96bdeb65f8717586e52e"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"slumber", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slumber --version")

    system bin/"slumber", "new"
    assert_match <<~YAML, (testpath/"slumber.yml").read
      profiles:
        example:
          name: Example Profile
          data:
            host: https://my-host
    YAML
  end
end
